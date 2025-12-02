import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../hot_desk_booking/providers/desk_providers.dart';

class CreateDeskDialog extends ConsumerStatefulWidget {
  const CreateDeskDialog({super.key, required this.onDeskCreated});

  final VoidCallback onDeskCreated;

  @override
  ConsumerState<CreateDeskDialog> createState() => _CreateDeskDialogState();
}

class _CreateDeskDialogState extends ConsumerState<CreateDeskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _workspaceController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _workspaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              TextFormField(
                controller: _workspaceController,
                decoration: const InputDecoration(
                  labelText: 'Workspace ID',
                  hintText: 'e.g., workspace-01',
                ),
                enabled: !_isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Workspace ID is required';
                  }
                  return null;
                },
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

    setState(() => _isSubmitting = true);

    final service = ref.read(deskServiceProvider);
    final (desk, error) = await service.createDesk(
      name: _nameController.text,
      workspaceId: _workspaceController.text,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      Navigator.of(context).pop();
      widget.onDeskCreated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desk created successfully')),
      );
    }
  }
}
