import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  /// Changes the current active tab index and notifies UI listening widgets
  void changeTab(int newIndex) {
    if (_currentIndex == newIndex) return; // Prevent unnecessary rebuilds
    _currentIndex = newIndex;
    notifyListeners();
  }
}
