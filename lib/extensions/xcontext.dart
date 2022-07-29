import 'package:flutter/material.dart';

extension XContext on BuildContext {
  double get getDeviceWidth => MediaQuery.of(this).size.width;

  /// height of device
  double get getDeviceHeight => MediaQuery.of(this).size.height;
}
