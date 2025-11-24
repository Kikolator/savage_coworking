import 'package:flutter/material.dart';

import 'hot_desk_booking_view.dart';
import 'widgets/hot_desk_booking_screen.dart';

class HotDeskBookingViewPhone extends StatelessWidget {
  const HotDeskBookingViewPhone({super.key, required this.props});

  final HotDeskBookingViewProps props;

  @override
  Widget build(BuildContext context) {
    return HotDeskBookingScreen(
      props: props,
      padding: const EdgeInsets.all(16),
      twoColumn: false,
    );
  }
}
