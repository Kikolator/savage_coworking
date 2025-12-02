import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../hot_desk_booking/models/desk.dart';
import '../../../../../hot_desk_booking/providers/desk_providers.dart';

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
  late bool _isActive;
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

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Workspace: ${widget.desk.workspaceId}',
                style: Theme.of(context).textTheme.bodySmall,
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

  Future<void> _updateDesk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final service = ref.read(deskServiceProvider);
    final error = await service.updateDesk(
      widget.desk.id,
      name: _nameController.text,
      isActive: _isActive,
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
      widget.onDeskUpdated();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Desk updated successfully')),
      );
    }
  }
}
