import 'package:flutter/material.dart';

class AppStyle {
  static BoxDecoration bottomSheetDecoration({Color? color, int? borderRadius}) =>  BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular((borderRadius ?? 12).toDouble())));

  static BoxDecoration searchDecoration({Color? color, int? borderRadius}) =>  BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular((borderRadius == null) ? 12 : borderRadius.toDouble()));
}
