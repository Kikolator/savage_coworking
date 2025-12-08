import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/admin_subscription_providers.dart';
import '../../../../models/admin_subscription_models.dart';
import '../../../../../subscription/models/subscription_interval.dart';
import '../../../../../subscription/models/billing_type.dart';
import '../../../../../subscription/models/billing_period.dart';
import '../../../../../subscription/models/plan_category.dart';
import '../../../../../subscription/models/access_type.dart';
import '../../../../../subscription/models/seat_type.dart';
import '../../../../../workspace/providers/workspace_selection_providers.dart';

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
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  late final TextEditingController _dayPassCreditsController;
  late final TextEditingController _intervalCountController;

  SubscriptionInterval _interval = SubscriptionInterval.month;
  String _currency = 'usd';
  bool _isActive = true;
  bool _isEditing = false;
  bool _taxIncluded = true;
  PlanCategory _category = PlanCategory.explore;
  AccessType _accessType = AccessType.business;
  List<int> _allowedDaysOfWeek = [];
  SeatType? _seatType;
  int _intervalCount = 1;

  @override
  void initState() {
    super.initState();
    final state = ref.read(adminSubscriptionViewModelProvider);
    final plan = state.selectedPlan;
    final workspaceAsync = ref.read(selectedWorkspaceProvider);

    _isEditing = plan != null;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _priceController = TextEditingController(
      text: plan != null ? (plan.pricing.amount / 100).toStringAsFixed(2) : '',
    );
    _deskHoursController = TextEditingController(
      text: plan?.quota.deskHoursPerPeriod?.toString() ?? '0',
    );
    _meetingRoomHoursController = TextEditingController(
      text: plan?.quota.meetingHoursPerPeriod?.toString() ?? '0',
    );
    _featuresController = TextEditingController(
      text: plan?.features.join('\n') ?? '',
    );

    // Initialize category and access type
    if (plan != null) {
      _category = plan.category;
      _accessType = plan.quota.access.type;
      _startTimeController = TextEditingController(
        text: plan.quota.access.startTime ?? '',
      );
      _endTimeController = TextEditingController(
        text: plan.quota.access.endTime ?? '',
      );
      _allowedDaysOfWeek = List<int>.from(plan.quota.access.allowedDaysOfWeek);
      _dayPassCreditsController = TextEditingController(
        text: plan.quota.dayPassCredits?.toString() ?? '',
      );
      _seatType = plan.quota.seatType;
      _intervalCount = plan.billing.intervalCount;
      // Map billing to interval for backward compatibility
      if (plan.billing.type == BillingType.recurring &&
          plan.billing.period == BillingPeriod.month) {
        _interval = SubscriptionInterval.month;
      } else {
        _interval = SubscriptionInterval.oneOff;
      }
      _currency = plan.pricing.currency;
      _isActive = plan.isActive;
      _taxIncluded = plan.pricing.taxIncluded;
    } else {
      // Initialize from workspace defaults if available
      final workspace = workspaceAsync.valueOrNull;
      final defaultStartTime = workspace?.businessHoursStart ?? '09:00';
      final defaultEndTime = workspace?.businessHoursEnd ?? '17:00';
      final defaultDays = workspace?.businessDaysOfWeek.isNotEmpty == true
          ? List<int>.from(workspace!.businessDaysOfWeek)
          : [1, 2, 3, 4, 5]; // Mon-Fri default

      _startTimeController = TextEditingController(text: defaultStartTime);
      _endTimeController = TextEditingController(text: defaultEndTime);
      _allowedDaysOfWeek = defaultDays;
      _dayPassCreditsController = TextEditingController();
      _intervalCountController = TextEditingController(text: '1');

      // Nomad category is always 24/7
      if (_category == PlanCategory.nomad) {
        _accessType = AccessType.$24_7;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _deskHoursController.dispose();
    _meetingRoomHoursController.dispose();
    _featuresController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _dayPassCreditsController.dispose();
    _intervalCountController.dispose();
    super.dispose();
  }

  // Helper methods for conditional field visibility
  bool get _showDayPassCredits => _category == PlanCategory.dayPass;
  bool get _showSeatType => _category == PlanCategory.fix;
  bool get _showDeskHours =>
      _category != PlanCategory.dayPass && _category != PlanCategory.fix;
  bool get _showMeetingRoomHours => _category != PlanCategory.dayPass;
  bool get _showTimeRestrictions => _accessType == AccessType.business;
  bool get _showIntervalCount =>
      _interval == SubscriptionInterval.month; // recurring

  // Currency helper methods
  String _getCurrencySymbol(String currency) {
    switch (currency.toLowerCase()) {
      case 'usd':
        return '\$';
      case 'eur':
        return '€';
      case 'gbp':
        return '£';
      default:
        return currency.toUpperCase();
    }
  }

  String _getCurrencyLabel(String currency) {
    switch (currency.toLowerCase()) {
      case 'usd':
        return 'USD';
      case 'eur':
        return 'EUR';
      case 'gbp':
        return 'GBP';
      default:
        return currency.toUpperCase();
    }
  }

  // Time format validation
  static bool _isValidTimeFormat(String? time) {
    if (time == null || time.isEmpty) return false;
    final regex = RegExp(r'^([0-1][0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);
    final state = ref.read(adminSubscriptionViewModelProvider);

    final priceInCents = (double.parse(_priceController.text) * 100).toInt();
    final deskHours = _showDeskHours
        ? (double.tryParse(_deskHoursController.text) ?? 0.0)
        : 0.0;
    final meetingRoomHours = _showMeetingRoomHours
        ? (double.tryParse(_meetingRoomHoursController.text) ?? 0.0)
        : 0.0;
    final features = _featuresController.text
        .split('\n')
        .where((f) => f.trim().isNotEmpty)
        .toList();

    // Map interval to billing type/period for new model
    final billingType = _interval == SubscriptionInterval.month
        ? BillingType.recurring
        : BillingType.oneOff;
    final billingPeriod = _interval == SubscriptionInterval.month
        ? BillingPeriod.month
        : null;

    // Validate conditional fields
    if (_showDayPassCredits) {
      final credits = int.tryParse(_dayPassCreditsController.text);
      if (credits == null || credits <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('DayPass credits must be a positive integer'),
          ),
        );
        return;
      }
    }

    if (_showSeatType && _seatType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seat type is required for fix plans')),
      );
      return;
    }

    if (_showTimeRestrictions) {
      if (!_isValidTimeFormat(_startTimeController.text) ||
          !_isValidTimeFormat(_endTimeController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Start and end times must be in HH:mm format'),
          ),
        );
        return;
      }
      final startTime = _startTimeController.text;
      final endTime = _endTimeController.text;
      if (startTime.isNotEmpty && endTime.isNotEmpty && startTime.compareTo(endTime) >= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be later than start time'),
          ),
        );
        return;
      }
    }

    if (_showIntervalCount) {
      final intervalCount = int.tryParse(_intervalCountController.text);
      if (intervalCount == null || intervalCount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Interval count must be a positive integer'),
          ),
        );
        return;
      }
      _intervalCount = intervalCount;
    }


    final formData = AdminPlanFormData(
      id: state.selectedPlan?.id,
      name: _nameController.text.trim(),
      category: _category,
      billingType: billingType,
      billingPeriod: billingPeriod,
      intervalCount: _intervalCount,
      price: priceInCents,
      currency: _currency,
      taxIncluded: _taxIncluded,
      deskHours: deskHours,
      meetingRoomHours: meetingRoomHours,
      dayPassCredits: _showDayPassCredits
          ? int.tryParse(_dayPassCreditsController.text)
          : null,
      accessType: _accessType,
      startTime: _showTimeRestrictions ? _startTimeController.text.trim() : null,
      endTime: _showTimeRestrictions ? _endTimeController.text.trim() : null,
      allowedDaysOfWeek:
          _showTimeRestrictions && _allowedDaysOfWeek.isNotEmpty
              ? _allowedDaysOfWeek
              : null,
      seatType: _seatType,
      features: features,
      isActive: _isActive,
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
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 1000),
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
                      DropdownButtonFormField<PlanCategory>(
                        value: _category,
                        decoration: const InputDecoration(
                          labelText: 'Plan Category *',
                        ),
                        items: PlanCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _category = value;
                              // Reset dependent fields when category changes
                              if (value != PlanCategory.fix) {
                                _seatType = null;
                              }
                              if (value != PlanCategory.dayPass) {
                                _dayPassCreditsController.clear();
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Access Type *',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<AccessType>(
                        segments: const [
                          ButtonSegment(
                            value: AccessType.business,
                            label: Text('Business Hours'),
                            icon: Icon(Icons.access_time),
                          ),
                          ButtonSegment(
                            value: AccessType.$24_7,
                            label: Text('24/7'),
                            icon: Icon(Icons.all_inclusive),
                          ),
                        ],
                        selected: {_accessType},
                        onSelectionChanged: (Set<AccessType> selected) {
                          setState(() => _accessType = selected.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_showTimeRestrictions) ...[
                        Text(
                          'Business Hours',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _startTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'Start Time *',
                                  hintText: '09:00',
                                  helperText: 'HH:mm format',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Start time is required';
                                  }
                                  if (!_isValidTimeFormat(value)) {
                                    return 'Must be in HH:mm format';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _endTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'End Time *',
                                  hintText: '17:00',
                                  helperText: 'HH:mm format',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'End time is required';
                                  }
                                  if (!_isValidTimeFormat(value)) {
                                    return 'Must be in HH:mm format';
                                  }
                                  final startTime = _startTimeController.text;
                                  if (startTime.isNotEmpty &&
                                      value.isNotEmpty &&
                                      value.compareTo(startTime) <= 0) {
                                    return 'Must be later than start time';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Allowed Days of Week',
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            for (int day = 0; day < 7; day++)
                              FilterChip(
                                label: Text(_getDayName(day)),
                                selected: _allowedDaysOfWeek.contains(day),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _allowedDaysOfWeek.add(day);
                                    } else {
                                      _allowedDaysOfWeek.remove(day);
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_showDayPassCredits) ...[
                        TextFormField(
                          controller: _dayPassCreditsController,
                          decoration: const InputDecoration(
                            labelText: 'DayPass Credits *',
                            hintText: '1, 5, or 10',
                            helperText: 'Number of daypass credits included',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'DayPass credits is required';
                            }
                            final credits = int.tryParse(value);
                            if (credits == null || credits <= 0) {
                              return 'Must be a positive integer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_showSeatType) ...[
                        DropdownButtonFormField<SeatType>(
                          value: _seatType,
                          decoration: const InputDecoration(
                            labelText: 'Seat Type *',
                          ),
                          items: SeatType.values.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type.label),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _seatType = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Seat type is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                labelText: 'Price (${_getCurrencyLabel(_currency)}) *',
                                hintText: '29.99',
                                prefixText: _getCurrencySymbol(_currency),
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
                                DropdownMenuItem(
                                  value: 'usd',
                                  child: Text('USD'),
                                ),
                                DropdownMenuItem(
                                  value: 'eur',
                                  child: Text('EUR'),
                                ),
                                DropdownMenuItem(
                                  value: 'gbp',
                                  child: Text('GBP'),
                                ),
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
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Tax included in price'),
                        subtitle: const Text(
                          'Whether tax is included in the price entered above',
                        ),
                        value: _taxIncluded,
                        onChanged: (value) => setState(() => _taxIncluded = value),
                        contentPadding: EdgeInsets.zero,
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
                        onSelectionChanged:
                            (Set<SubscriptionInterval> selected) {
                              setState(() => _interval = selected.first);
                            },
                      ),
                      if (_showIntervalCount) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _intervalCountController,
                          decoration: const InputDecoration(
                            labelText: 'Interval Count *',
                            hintText: '1',
                            helperText: 'Number of billing periods (e.g., 1 = monthly, 3 = quarterly)',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Interval count is required';
                            }
                            final count = int.tryParse(value);
                            if (count == null || count <= 0) {
                              return 'Must be a positive integer';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (_showDeskHours && _showMeetingRoomHours) ...[
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
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
                      ] else if (_showMeetingRoomHours) ...[
                        TextFormField(
                          controller: _meetingRoomHoursController,
                          decoration: const InputDecoration(
                            labelText: 'Meeting Room Hours *',
                            hintText: '0 = unlimited',
                            helperText: 'Enter 0 for unlimited',
                          ),
                          keyboardType:
                              const TextInputType.numberWithOptions(
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
                        const SizedBox(height: 16),
                      ],
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
                      SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text(
                          'Plan is available for subscription',
                        ),
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

  String _getDayName(int day) {
    switch (day) {
      case 0:
        return 'Sun';
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      default:
        return '';
    }
  }
}
