import 'package:flutter/material.dart';

import 'hot_desk_booking_view.dart';
import 'widgets/hot_desk_booking_screen.dart';

class HotDeskBookingViewDesktop extends StatelessWidget {
  const HotDeskBookingViewDesktop({super.key, required this.props});

  final HotDeskBookingViewProps props;

  @override
  Widget build(BuildContext context) {
    return HotDeskBookingScreen(
      props: props,
      padding: const EdgeInsets.all(32),
      maxWidth: 1200,
      twoColumn: true,
    );
  }
}
