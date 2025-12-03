import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../hot_desk_booking/providers/desk_providers.dart';
import '../../../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';

class CreateDeskDialog extends ConsumerStatefulWidget {
  const CreateDeskDialog({super.key, required this.onDeskCreated});

  final VoidCallback onDeskCreated;

  @override
  ConsumerState<CreateDeskDialog> createState() => _CreateDeskDialogState();
}

class _CreateDeskDialogState extends ConsumerState<CreateDeskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _selectedWorkspaceId;
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final workspacesAsync = ref.watch(activeWorkspacesFutureProvider);

    return AlertDialog(
      title: const Text('Create New Desk'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Desk Name',
                  hintText: 'e.g., Desk 21A',
                ),
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Desk name is required';
                  }
                  if (value.trim().length > 100) {
                    return 'Desk name must be 100 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Workspace Dropdown
              workspacesAsync.when(
                data: (workspaces) {
                  if (workspaces.isEmpty) {
                    return const Text(
                      'No workspaces available. Please create a workspace first.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedWorkspaceId,
                    decoration: const InputDecoration(
                      labelText: 'Workspace',
                      hintText: 'Select a workspace',
                    ),
                    items: workspaces.map((workspace) {
                      return DropdownMenuItem<String>(
                        value: workspace.id,
                        child: Text(workspace.name),
                      );
                    }).toList(),
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _selectedWorkspaceId = value;
                            });
                          },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Workspace is required';
                      }
                      return null;
                    },
                  );
                },
                loading: () => const SizedBox(
                  height: 48,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Text(
                  'Error loading workspaces: ${error.toString()}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: 16),
              // Active/Inactive Switch
              Row(
                children: [
                  Text('Active', style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Switch(
                    value: _isActive,
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Image Picker
              Text(
                'Desk Image (Optional)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              if (_selectedImage != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _isSubmitting ? null : _removeImage,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _pickImage,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Select Image'),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _createDesk,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createDesk() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedWorkspaceId == null || _selectedWorkspaceId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a workspace'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        final storageService = ref.read(storageServiceProvider);
        // Create a temporary desk ID for image upload
        // We'll update it after desk creation
        final tempDeskId = DateTime.now().millisecondsSinceEpoch.toString();
        imageUrl = await storageService.uploadDeskImage(
          deskId: tempDeskId,
          imageFile: _selectedImage!,
        );
      }

      // Create desk
      final deskService = ref.read(deskServiceProvider);
      final (desk, error) = await deskService.createDesk(
        name: _nameController.text,
        workspaceId: _selectedWorkspaceId!,
        imageUrl: imageUrl,
        isActive: _isActive,
      );

      if (!mounted) return;

      if (error != null) {
        // If desk creation failed but image was uploaded, try to delete image
        if (imageUrl != null) {
          try {
            final storageService = ref.read(storageServiceProvider);
            await storageService.deleteDeskImage(imageUrl);
          } catch (_) {
            // Ignore deletion errors
          }
        }

        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      // If desk was created successfully but we used a temp ID for image,
      // we need to re-upload the image with the correct desk ID
      if (_selectedImage != null && desk != null && imageUrl != null) {
        try {
          final storageService = ref.read(storageServiceProvider);
          // Delete old image with temp ID
          await storageService.deleteDeskImage(imageUrl);
          // Upload with correct desk ID
          final newImageUrl = await storageService.uploadDeskImage(
            deskId: desk.id,
            imageFile: _selectedImage!,
          );
          // Update desk with correct image URL
          await deskService.updateDesk(desk.id, imageUrl: newImageUrl);
        } catch (e) {
          // Log error but don't fail the creation
          // Image upload can be retried later
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Desk created but image upload failed: ${e.toString()}',
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }

      if (!mounted) return;

      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      widget.onDeskCreated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desk created successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create desk: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
