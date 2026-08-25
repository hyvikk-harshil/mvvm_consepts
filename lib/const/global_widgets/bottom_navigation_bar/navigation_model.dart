import 'package:flutter/material.dart';

class NavItemModel {
  final Widget icon;
  final Widget screen;
  final String label;

  const NavItemModel({
    required this.icon,
    required this.screen,
    required this.label,
  });
}
