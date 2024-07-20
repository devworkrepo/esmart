import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetUtil{
  static statusBarColor(Color color){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: color));
  }
}