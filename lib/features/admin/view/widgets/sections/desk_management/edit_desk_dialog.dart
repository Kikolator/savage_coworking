import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../hot_desk_booking/models/desk.dart';
import '../../../../../hot_desk_booking/providers/desk_providers.dart';
import '../../../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';

class EditDeskDialog extends ConsumerStatefulWidget {
  const EditDeskDialog({
    super.key,
    required this.desk,
    required this.onDeskUpdated,
  });

  final Desk desk;
  final VoidCallback onDeskUpdated;

  @override
  ConsumerState<EditDeskDialog> createState() => _EditDeskDialogState();
}

class _EditDeskDialogState extends ConsumerState<EditDeskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _imagePicker = ImagePicker();
  late bool _isActive;
  XFile? _selectedImage;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.desk.name);
    _isActive = widget.desk.isActive;
  }

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
      title: const Text('Edit Desk'),
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
              Row(
                children: [
                  Text('Active', style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Switch(
                    value: _isActive,
                    onChanged: _isSubmitting
                        ? null
                        : (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              workspacesAsync.when(
                data: (workspaces) {
                  try {
                    final workspace = workspaces.firstWhere(
                      (w) => w.id == widget.desk.workspaceId,
                    );
                    return Text(
                      'Workspace: ${workspace.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  } catch (_) {
                    // Workspace not found, fallback to ID
                    return Text(
                      'Workspace: ${widget.desk.workspaceId}',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }
                },
                loading: () => Text(
                  'Workspace: ${widget.desk.workspaceId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                error: (_, __) => Text(
                  'Workspace: ${widget.desk.workspaceId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 16),
              // Image Display and Editing
              Text(
                'Desk Image',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _buildImageSection(context),
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
          onPressed: _isSubmitting ? null : _updateDesk,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final currentImageUrl = widget.desk.imageUrl;
    final hasNewImage = _selectedImage != null;
    final hasCurrentImage = currentImageUrl != null && currentImageUrl.isNotEmpty;

    if (hasNewImage) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 150,
              child: kIsWeb
                  ? Image.network(
                      _selectedImage!.path,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_selectedImage!.path),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
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
      );
    }

    if (hasCurrentImage) {
      final imageUrl = currentImageUrl; // Safe because hasCurrentImage checks for null
      return GestureDetector(
        onTap: _isSubmitting ? null : _pickImage,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 150,
                child: Image.network(
                  imageUrl,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: _isSubmitting ? null : _pickImage,
      icon: const Icon(Icons.add_photo_alternate),
      label: const Text('Select Image'),
    );
  }

  Future<void> _updateDesk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      String? imageUrl;
      final hasNewImage = _selectedImage != null;

      // Upload new image if selected
      if (hasNewImage) {
        final storageService = ref.read(storageServiceProvider);
        imageUrl = await storageService.uploadDeskImage(
          deskId: widget.desk.id,
          imageFile: _selectedImage!,
        );

        // Delete old image if it exists
        final oldImageUrl = widget.desk.imageUrl;
        if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
          try {
            await storageService.deleteDeskImage(oldImageUrl);
          } catch (_) {
            // Ignore deletion errors
          }
        }
      }

      // Update desk - only pass imageUrl if we have a new one, otherwise keep existing
      final service = ref.read(deskServiceProvider);
      final error = await service.updateDesk(
        widget.desk.id,
        name: _nameController.text,
        isActive: _isActive,
        imageUrl: imageUrl, // null if no new image, will keep existing
      );

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      if (error != null) {
        // If desk update failed but new image was uploaded, try to delete new image
        if (imageUrl != null) {
          try {
            final storageService = ref.read(storageServiceProvider);
            await storageService.deleteDeskImage(imageUrl);
          } catch (_) {
            // Ignore deletion errors
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else {
        Navigator.of(context).pop();
        widget.onDeskUpdated();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Desk updated successfully')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update desk: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
