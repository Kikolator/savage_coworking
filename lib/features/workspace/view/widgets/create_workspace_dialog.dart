import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';

class CreateWorkspaceDialog extends ConsumerStatefulWidget {
  const CreateWorkspaceDialog({super.key, required this.onWorkspaceCreated});

  final VoidCallback onWorkspaceCreated;

  @override
  ConsumerState<CreateWorkspaceDialog> createState() =>
      _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends ConsumerState<CreateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _countryController = TextEditingController();
  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isSubmitting = false;
  bool _isLoadingImage = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoadingImage = true;
    });

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        // Small delay to show loading indicator
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          setState(() {
            _selectedImage = image;
            _isLoadingImage = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingImage = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingImage = false;
        });
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

  Future<void> _createWorkspace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    String? logoUrl;
    if (_selectedImage != null) {
      try {
        // We'll upload the logo after creating the workspace
        // For now, we'll use a temporary ID
        final tempWorkspaceId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final storageService = ref.read(storageServiceProvider);
        logoUrl = await storageService.uploadWorkspaceLogo(
          workspaceId: tempWorkspaceId,
          imageFile: _selectedImage!,
        );
        if (logoUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Workspace created but logo upload failed.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logo upload failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // Continue with workspace creation even if logo upload fails
      }
    }

    final service = ref.read(workspaceServiceProvider);
    final (workspace, error) = await service.createWorkspace(
      name: _nameController.text,
      location: _locationController.text,
      country: _countryController.text,
      companyLogoUrl: logoUrl,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (workspace == null) {
      setState(() => _isSubmitting = false);
      return;
    }

    // If logo was uploaded with temp ID, re-upload with actual workspace ID
    // Do this BEFORE closing the dialog to avoid disposed view errors
    if (_selectedImage != null && logoUrl != null) {
      try {
        if (!mounted) return;
        final storageService = ref.read(storageServiceProvider);
        final newLogoUrl = await storageService.uploadWorkspaceLogo(
          workspaceId: workspace.id,
          imageFile: _selectedImage!,
        );
        if (newLogoUrl != null && newLogoUrl != logoUrl) {
          // Update workspace with new logo URL
          await service.updateWorkspace(
            workspace.id,
            companyLogoUrl: newLogoUrl,
          );
          // Delete old logo
          await storageService.deleteWorkspaceLogo(logoUrl);
        }
      } catch (e) {
        // Log error but don't fail the creation
        debugPrint('Failed to update logo URL: $e');
      }
    }

    // All async operations complete, now close dialog and show success
    if (!mounted) return;

    setState(() => _isSubmitting = false);

    // Show success message before closing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workspace created successfully')),
    );

    Navigator.of(context).pop(true); // Return true to indicate success
    widget.onWorkspaceCreated();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Workspace'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Workspace Name',
                  hintText: 'e.g., Main Office',
                ),
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Workspace name is required';
                  }
                  if (value.trim().length > 100) {
                    return 'Workspace name must be 100 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., 123 Main St, New York',
                ),
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Location is required';
                  }
                  if (value.trim().length > 200) {
                    return 'Location must be 200 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  hintText: 'e.g., United States',
                ),
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Country is required';
                  }
                  if (value.trim().length > 100) {
                    return 'Country must be 100 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_isLoadingImage) ...[
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 16),
              ] else if (_selectedImage != null) ...[
                kIsWeb
                    ? Image.network(
                        _selectedImage!.path,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_selectedImage!.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _isSubmitting ? null : _removeImage,
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove Logo'),
                ),
                const SizedBox(height: 16),
              ],
              if (!_isLoadingImage && _selectedImage == null)
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Logo (Optional)'),
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
          onPressed: _isSubmitting ? null : _createWorkspace,
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
}
