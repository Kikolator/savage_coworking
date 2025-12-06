import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/admin_subscription_providers.dart';
import '../../../../viewmodel/admin_subscription_view_model.dart';
import '../../../../models/admin_subscription_models.dart';
import '../../../../../subscription/models/subscription_interval.dart';

class AdminPlanFormDialog extends ConsumerStatefulWidget {
  const AdminPlanFormDialog({super.key});

  @override
  ConsumerState<AdminPlanFormDialog> createState() =>
      _AdminPlanFormDialogState();
}

class _AdminPlanFormDialogState extends ConsumerState<AdminPlanFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _deskHoursController;
  late final TextEditingController _meetingRoomHoursController;
  late final TextEditingController _featuresController;
  late final TextEditingController _stripePriceIdController;
  late final TextEditingController _stripeProductIdController;

  SubscriptionInterval _interval = SubscriptionInterval.month;
  String _currency = 'usd';
  bool _isActive = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(adminSubscriptionViewModelProvider);
    final plan = state.selectedPlan;

    _isEditing = plan != null;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _priceController = TextEditingController(
      text: plan != null ? (plan.price / 100).toStringAsFixed(2) : '',
    );
    _deskHoursController = TextEditingController(
      text: plan?.deskHours.toString() ?? '0',
    );
    _meetingRoomHoursController = TextEditingController(
      text: plan?.meetingRoomHours.toString() ?? '0',
    );
    _featuresController = TextEditingController(
      text: plan?.features.join('\n') ?? '',
    );
    _stripePriceIdController = TextEditingController(
      text: plan?.stripePriceId ?? '',
    );
    _stripeProductIdController = TextEditingController(
      text: plan?.stripeProductId ?? '',
    );

    if (plan != null) {
      _interval = plan.interval;
      _currency = plan.currency;
      _isActive = plan.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _deskHoursController.dispose();
    _meetingRoomHoursController.dispose();
    _featuresController.dispose();
    _stripePriceIdController.dispose();
    _stripeProductIdController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);
    final state = ref.read(adminSubscriptionViewModelProvider);

    final priceInCents = (double.parse(_priceController.text) * 100).toInt();
    final deskHours = double.tryParse(_deskHoursController.text) ?? 0.0;
    final meetingRoomHours =
        double.tryParse(_meetingRoomHoursController.text) ?? 0.0;
    final features = _featuresController.text
        .split('\n')
        .where((f) => f.trim().isNotEmpty)
        .toList();

    final formData = AdminPlanFormData(
      id: state.selectedPlan?.id,
      name: _nameController.text.trim(),
      price: priceInCents,
      currency: _currency,
      interval: _interval,
      deskHours: deskHours,
      meetingRoomHours: meetingRoomHours,
      features: features,
      isActive: _isActive,
      stripePriceId: _stripePriceIdController.text.trim().isEmpty
          ? null
          : _stripePriceIdController.text.trim(),
      stripeProductId: _stripeProductIdController.text.trim().isEmpty
          ? null
          : _stripeProductIdController.text.trim(),
    );

    if (_isEditing && state.selectedPlan != null) {
      await viewModel.updatePlan(state.selectedPlan!.id, formData);
    } else {
      await viewModel.createPlan(formData);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(adminSubscriptionViewModelProvider);

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _isEditing ? 'Edit Plan' : 'Create Plan',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Plan Name *',
                          hintText: 'e.g., Basic, Pro, Enterprise',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Plan name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price (USD) *',
                                hintText: '29.99',
                                prefixText: '\$',
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Price is required';
                                }
                                final price = double.tryParse(value);
                                if (price == null || price <= 0) {
                                  return 'Price must be greater than 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _currency,
                              decoration: const InputDecoration(
                                labelText: 'Currency',
                              ),
                              items: const [
                                DropdownMenuItem(value: 'usd', child: Text('USD')),
                                DropdownMenuItem(value: 'eur', child: Text('EUR')),
                                DropdownMenuItem(value: 'gbp', child: Text('GBP')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _currency = value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Billing Interval *',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<SubscriptionInterval>(
                        segments: const [
                          ButtonSegment(
                            value: SubscriptionInterval.month,
                            label: Text('Monthly'),
                            icon: Icon(Icons.repeat),
                          ),
                          ButtonSegment(
                            value: SubscriptionInterval.oneOff,
                            label: Text('One-time'),
                            icon: Icon(Icons.payment),
                          ),
                        ],
                        selected: {_interval},
                        onSelectionChanged: (Set<SubscriptionInterval> selected) {
                          setState(() => _interval = selected.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _deskHoursController,
                              decoration: const InputDecoration(
                                labelText: 'Desk Hours *',
                                hintText: '0 = unlimited',
                                helperText: 'Enter 0 for unlimited',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Desk hours is required';
                                }
                                final hours = double.tryParse(value);
                                if (hours == null || hours < 0) {
                                  return 'Must be 0 or greater';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _meetingRoomHoursController,
                              decoration: const InputDecoration(
                                labelText: 'Meeting Room Hours *',
                                hintText: '0 = unlimited',
                                helperText: 'Enter 0 for unlimited',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Meeting room hours is required';
                                }
                                final hours = double.tryParse(value);
                                if (hours == null || hours < 0) {
                                  return 'Must be 0 or greater';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _featuresController,
                        decoration: const InputDecoration(
                          labelText: 'Features',
                          hintText: 'Enter one feature per line',
                          helperText: 'One feature per line',
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      if (_interval == SubscriptionInterval.month) ...[
                        TextFormField(
                          controller: _stripePriceIdController,
                          decoration: const InputDecoration(
                            labelText: 'Stripe Price ID *',
                            hintText: 'price_...',
                            helperText: 'Required for recurring plans',
                          ),
                          validator: _interval == SubscriptionInterval.month
                              ? (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Stripe Price ID is required for recurring plans';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _stripeProductIdController,
                        decoration: const InputDecoration(
                          labelText: 'Stripe Product ID',
                          hintText: 'prod_...',
                          helperText: 'Optional',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text('Plan is available for subscription'),
                        value: _isActive,
                        onChanged: (value) => setState(() => _isActive = value),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: state.isLoading ? null : _handleSubmit,
                      child: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isEditing ? 'Update' : 'Create'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

