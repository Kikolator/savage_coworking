import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../hot_desk_booking/models/workspace.dart';
import '../../../hot_desk_booking/providers/workspace_providers.dart';
import '../../../hot_desk_booking/providers/hot_desk_booking_providers.dart';

class EditWorkspaceDialog extends ConsumerStatefulWidget {
  const EditWorkspaceDialog({
    super.key,
    required this.workspace,
    required this.onWorkspaceUpdated,
  });

  final Workspace workspace;
  final VoidCallback onWorkspaceUpdated;

  @override
  ConsumerState<EditWorkspaceDialog> createState() =>
      _EditWorkspaceDialogState();
}

class _EditWorkspaceDialogState extends ConsumerState<EditWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _countryController;
  final _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isSubmitting = false;
  bool _isLoadingImage = false;
  String? _existingLogoUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace.name);
    _locationController = TextEditingController(text: widget.workspace.location);
    _countryController = TextEditingController(text: widget.workspace.country);
    _existingLogoUrl = widget.workspace.companyLogoUrl;
  }

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
      _existingLogoUrl = null;
    });
  }

  Future<void> _updateWorkspace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final service = ref.read(workspaceServiceProvider);
    String? logoUrl = _existingLogoUrl;

    // Upload new logo if one was selected
    if (_selectedImage != null) {
      try {
        final storageService = ref.read(storageServiceProvider);
        logoUrl = await storageService.uploadWorkspaceLogo(
          workspaceId: widget.workspace.id,
          imageFile: _selectedImage!,
        );
      } catch (e) {
        debugPrint('Failed to upload logo: $e');
        // Continue with update even if logo upload fails
      }
    }

    // Update workspace with all fields
    final error = await service.updateWorkspace(
      widget.workspace.id,
      name: _nameController.text,
      location: _locationController.text,
      country: _countryController.text,
      companyLogoUrl: logoUrl,
    );

    if (!mounted) {
      setState(() => _isSubmitting = false);
      return;
    }

    if (error != null) {
      setState(() => _isSubmitting = false);
      // Close dialog first, then show error
      Navigator.of(context).pop(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
      return;
    }

    setState(() => _isSubmitting = false);

    // Close dialog first, then show success and trigger callback
    Navigator.of(context).pop(true);
    widget.onWorkspaceUpdated();

    // Show success message after dialog is closed
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLogo = _selectedImage != null || _existingLogoUrl != null;

    return AlertDialog(
      title: const Text('Edit Workspace'),
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
              ] else if (hasLogo) ...[
                _selectedImage != null
                    ? (kIsWeb
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
                          ))
                    : (_existingLogoUrl != null
                        ? Image.network(
                            _existingLogoUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 100,
                                width: 100,
                                child: Icon(Icons.broken_image),
                              );
                            },
                          )
                        : const SizedBox.shrink()),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _isSubmitting ? null : _removeImage,
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove Logo'),
                ),
                const SizedBox(height: 16),
              ],
              if (!_isLoadingImage && !hasLogo)
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Upload Logo (Optional)'),
                ),
              if (!_isLoadingImage && hasLogo)
                FilledButton.icon(
                  onPressed: _isSubmitting ? null : _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Change Logo'),
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
          onPressed: _isSubmitting ? null : _updateWorkspace,
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
}

