import 'package:flutter/material.dart';
import 'package:mvvm_consepts/const/global_widgets/bottom_navigation_bar/navigation_model.dart';
import 'package:mvvm_consepts/const/global_widgets/bottom_navigation_bar/navigation_view.dart';
import 'package:mvvm_consepts/const/global_widgets/bottom_navigation_bar/navigation_viewmodel.dart';
import 'package:mvvm_consepts/const/global_widgets/drawer/navigation_drawer.dart';
import 'package:provider/provider.dart';
import 'attendance_dashboard.dart';

class AttendanceNavBar extends StatelessWidget {
  const AttendanceNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Declare the screens for this specific dashboard
    final List<NavItemModel> tabs = [
      const NavItemModel(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
        screen: AttendanceDashboard(),
      ),
      const NavItemModel(
        icon: Icon(Icons.camera_alt_outlined),
        label: 'Selfie',
        screen: AttendanceDashboard(),
      ), const NavItemModel(
        icon: Icon(Icons.leave_bags_at_home_outlined),
        label: 'Leave',
        screen: AttendanceDashboard(),
      ), const NavItemModel(
        icon: Icon(Icons.person_outline_outlined),
        label: 'Profile',
        screen: AttendanceDashboard(),
      ),
    ];


    // 2. Wrap your view layout inside a ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (_) => NavigationViewModel(),
      child: ReusableNavShell(
        navItems: tabs,
        drawer: const NavDrawer(),
      ),
    );
  }
}






