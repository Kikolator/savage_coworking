import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/desk.dart';
import '../../providers/desk_providers.dart';
import '../../providers/hot_desk_booking_providers.dart';
import 'desk_card_widget.dart';
import 'empty_state_widget.dart';
import 'skeleton_loading_widget.dart';

class DeskSelectorWidget extends ConsumerStatefulWidget {
  const DeskSelectorWidget({
    super.key,
    required this.selectedDeskId,
    required this.onDeskSelected,
    this.workspaceId,
    this.startAt,
    this.endAt,
  });

  final String? selectedDeskId;
  final ValueChanged<String?> onDeskSelected;
  final String? workspaceId;
  final DateTime? startAt;
  final DateTime? endAt;

  @override
  ConsumerState<DeskSelectorWidget> createState() =>
      _DeskSelectorWidgetState();
}

class _DeskSelectorWidgetState extends ConsumerState<DeskSelectorWidget> {
  String _searchQuery = '';
  String? _selectedWorkspaceFilter;

  @override
  Widget build(BuildContext context) {
    final desksAsync = ref.watch(availableDesksProvider(widget.workspaceId));

    return desksAsync.when(
      data: (desks) {
        if (desks.isEmpty) {
          return NoDesksEmptyState(
            hasFilter: widget.workspaceId != null,
            onClearFilter: widget.workspaceId != null
                ? () {
                    // Clear workspace filter - handled by parent
                  }
                : null,
          );
        }

        // Filter by search query
        final filteredDesks = desks.where((desk) {
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            if (!desk.name.toLowerCase().contains(query) &&
                !desk.workspaceId.toLowerCase().contains(query)) {
              return false;
            }
          }
          if (_selectedWorkspaceFilter != null &&
              desk.workspaceId != _selectedWorkspaceFilter) {
            return false;
          }
          return true;
        }).toList();

        // Get unique workspaces for filter chips
        final workspaces = desks.map((d) => d.workspaceId).toSet().toList()
          ..sort();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Semantics(
              label: 'Search desks by name or workspace',
              textField: true,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search desks...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() => _searchQuery = '');
                          },
                          tooltip: 'Clear search',
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),
            const SizedBox(height: 12),
            // Workspace filter chips
            if (workspaces.length > 1)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedWorkspaceFilter == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedWorkspaceFilter = selected ? null : null;
                      });
                    },
                  ),
                  ...workspaces.map(
                    (workspace) => FilterChip(
                      label: Text(workspace),
                      selected: _selectedWorkspaceFilter == workspace,
                      onSelected: (selected) {
                        setState(() {
                          _selectedWorkspaceFilter =
                              selected ? workspace : null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            if (workspaces.length > 1) const SizedBox(height: 12),
            // Desk grid
            if (filteredDesks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'No desks match your search',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              )
            else
              _DeskGrid(
                desks: filteredDesks,
                selectedDeskId: widget.selectedDeskId,
                onDeskSelected: widget.onDeskSelected,
                startAt: widget.startAt,
                endAt: widget.endAt,
              ),
          ],
        );
      },
      loading: () => const DeskGridSkeleton(),
      error: (error, stack) => Center(
        child: Column(
          children: [
            Text(
              'Error loading desks: $error',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(availableDesksProvider(widget.workspaceId));
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeskGrid extends ConsumerWidget {
  const _DeskGrid({
    required this.desks,
    required this.selectedDeskId,
    required this.onDeskSelected,
    this.startAt,
    this.endAt,
  });

  final List<Desk> desks;
  final String? selectedDeskId;
  final ValueChanged<String?> onDeskSelected;
  final DateTime? startAt;
  final DateTime? endAt;

  Future<DeskAvailability> _checkAvailability(
    Desk desk,
    WidgetRef ref,
  ) async {
    if (!desk.isActive) {
      return DeskAvailability.booked;
    }

    if (startAt == null || endAt == null) {
      return DeskAvailability.available;
    }

    final repository = ref.read(hotDeskBookingRepositoryProvider);
    final hasConflict = await repository.hasConflictingBooking(
      deskId: desk.id,
      startAt: startAt!,
      endAt: endAt!,
    );

    if (hasConflict) {
      return DeskAvailability.booked;
    }

    // Check if booking starts soon (within 1 hour)
    final now = DateTime.now().toUtc();
    if (startAt!.difference(now).inHours < 1 &&
        startAt!.difference(now).inHours >= 0) {
      return DeskAvailability.soonAvailable;
    }

    return DeskAvailability.available;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: desks.length,
          itemBuilder: (context, index) {
            final desk = desks[index];
            return FutureBuilder<DeskAvailability>(
              future: _checkAvailability(desk, ref),
              builder: (context, snapshot) {
                final availability = snapshot.data ??
                    (desk.isActive
                        ? DeskAvailability.available
                        : DeskAvailability.booked);

                return DeskCard(
                  desk: desk,
                  isSelected: selectedDeskId == desk.id,
                  availability: availability,
                  onTap: availability == DeskAvailability.available
                      ? () => onDeskSelected(desk.id)
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}

