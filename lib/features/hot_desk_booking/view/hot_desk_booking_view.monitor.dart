import 'package:flutter/material.dart';

import 'hot_desk_booking_view.dart';
import 'widgets/hot_desk_booking_screen.dart';

class HotDeskBookingViewMonitor extends StatelessWidget {
  const HotDeskBookingViewMonitor({super.key, required this.props});

  final HotDeskBookingViewProps props;

  @override
  Widget build(BuildContext context) {
    return HotDeskBookingScreen(
      props: props,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
      maxWidth: 1440,
      twoColumn: true,
    );
  }
}
