import 'package:flutter/material.dart';

import '../../models/hot_desk_booking.dart';
import '../hot_desk_booking_view.dart';
import 'booking_group_widget.dart';
import 'empty_state_widget.dart';

class BookingsListWidget extends StatelessWidget {
  const BookingsListWidget({
    super.key,
    required this.bookings,
    required this.props,
  });

  final List<HotDeskBooking> bookings;
  final HotDeskBookingViewProps props;

  List<BookingGroup> _groupBookings(List<HotDeskBooking> bookings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekStart = today.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final groups = <BookingGroup>[];

    // Today
    final todayBookings = bookings.where((b) {
      final bookingDate = DateTime(
        b.startAt.year,
        b.startAt.month,
        b.startAt.day,
      );
      return bookingDate == today;
    }).toList();
    if (todayBookings.isNotEmpty) {
      groups.add(BookingGroup(
        label: 'Today',
        bookings: todayBookings,
      ));
    }

    // Tomorrow
    final tomorrowBookings = bookings.where((b) {
      final bookingDate = DateTime(
        b.startAt.year,
        b.startAt.month,
        b.startAt.day,
      );
      return bookingDate == tomorrow;
    }).toList();
    if (tomorrowBookings.isNotEmpty) {
      groups.add(BookingGroup(
        label: 'Tomorrow',
        bookings: tomorrowBookings,
      ));
    }

    // This Week
    final thisWeekBookings = bookings.where((b) {
      final bookingDate = DateTime(
        b.startAt.year,
        b.startAt.month,
        b.startAt.day,
      );
      return bookingDate.isAfter(tomorrow) &&
          bookingDate.isBefore(weekEnd);
    }).toList();
    if (thisWeekBookings.isNotEmpty) {
      groups.add(BookingGroup(
        label: 'This Week',
        bookings: thisWeekBookings,
      ));
    }

    // Later
    final laterBookings = bookings.where((b) {
      final bookingDate = DateTime(
        b.startAt.year,
        b.startAt.month,
        b.startAt.day,
      );
      return bookingDate.isAfter(weekEnd) || bookingDate.isBefore(today);
    }).toList();
    if (laterBookings.isNotEmpty) {
      groups.add(BookingGroup(
        label: 'Later',
        bookings: laterBookings,
      ));
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return NoBookingsEmptyState(
        onBookDesk: () {
          // Scroll to top or focus on booking form
          // This will be handled by parent
        },
      );
    }

    final groups = _groupBookings(bookings);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming bookings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...groups.map(
          (group) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: BookingGroupWidget(
              dateLabel: group.label,
              bookings: group.bookings,
              props: props,
              initiallyExpanded: group.label == 'Today',
            ),
          ),
        ),
      ],
    );
  }
}

class BookingGroup {
  BookingGroup({
    required this.label,
    required this.bookings,
  });

  final String label;
  final List<HotDeskBooking> bookings;
}

