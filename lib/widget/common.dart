import 'package:flutter/material.dart';
import 'package:get/get.dart';

showFailureSnackbar({
  required String title,
  required String message,
}) {
    Get.snackbar(title, message,
      backgroundColor: Colors.red, colorText: Colors.white);
}


showSuccessSnackbar({
  required String title,
  required String message,
  SnackPosition position = SnackPosition.TOP

}) {

  Get.snackbar(title, message,
      backgroundColor: Colors.green,
      colorText: Colors.white,snackPosition: position);
}
