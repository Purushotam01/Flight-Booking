import 'package:flutter/material.dart';

extension ResponsiveX on BuildContext {
  static const double _mobile = 600;
  static const double _tablet = 1024;

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < _mobile;
  bool get isTablet => screenWidth >= _mobile && screenWidth < _tablet;
  bool get isDesktop => screenWidth >= _tablet;

  double rs(double base, {double tab = 4, double desk = 8}) {
    if (isTablet) return base + tab;
    if (isDesktop) return base + desk;
    return base;
  }

  double rf(double base, {double tab = 2, double desk = 4}) {
    if (isTablet) return base + tab;
    if (isDesktop) return base + desk;
    return base;
  }
}
