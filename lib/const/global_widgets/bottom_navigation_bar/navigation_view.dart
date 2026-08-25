import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navigation_model.dart';
import 'navigation_viewmodel.dart';

class ReusableNavShell extends StatelessWidget {
  final List<NavItemModel> navItems;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Color? indicatorColor;
  final Color? bottomNavBarColor;

  const ReusableNavShell({
    super.key,
    required this.navItems,
    this.appBar,
    this.drawer,
    this.indicatorColor,
    this.bottomNavBarColor,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Listen closely to our ViewModel changes
    final navigationVm = context.watch<NavigationViewModel>();

    return Scaffold(
      appBar: appBar,
      drawer: drawer,

      // 2. Display the screen bound to the current index
      body: IndexedStack(
        index: navigationVm.currentIndex,
        children: navItems.map((item) => item.screen).toList(),
      ),

      // 3. Render the Navigation Bar dynamically
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationVm.currentIndex,
        indicatorColor: indicatorColor,
        backgroundColor: bottomNavBarColor,
        onDestinationSelected: (index) => navigationVm.changeTab(index),
        destinations: navItems.map((item) {
          return NavigationDestination(
            icon: item.icon,
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
