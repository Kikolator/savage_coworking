import 'package:flutter/material.dart';

import 'hot_desk_booking_view.dart';
import 'widgets/hot_desk_booking_screen.dart';

class HotDeskBookingViewTablet extends StatelessWidget {
  const HotDeskBookingViewTablet({super.key, required this.props});

  final HotDeskBookingViewProps props;

  @override
  Widget build(BuildContext context) {
    return HotDeskBookingScreen(
      props: props,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      maxWidth: 900,
      twoColumn: false,
    );
  }
}
