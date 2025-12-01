import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final bool isSidebarExpanded;

  const DashboardState({this.isSidebarExpanded = true});

  DashboardState copyWith({bool? isSidebarExpanded}) {
    return DashboardState(
      isSidebarExpanded: isSidebarExpanded ?? this.isSidebarExpanded,
    );
  }
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  DashboardViewModel() : super(const DashboardState());

  void toggleSidebar() {
    state = state.copyWith(isSidebarExpanded: !state.isSidebarExpanded);
  }

  void setSidebarExpanded(bool expanded) {
    state = state.copyWith(isSidebarExpanded: expanded);
  }
}


