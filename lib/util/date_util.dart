import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static final DateFormat formatter = DateFormat('dd-MM-yyyy');

  static showDatePickerDialog(Function(String) onPick) async {
    DateTime? dateTime = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (dateTime != null) onPick(formatter.format(dateTime));
  }

  static String currentDateInYyyyMmDd({int? dayBefore}) {
    if (dayBefore == null) {
      return formatter.format(DateTime.now());
    } else {
      return formatter
          .format(DateTime.now().subtract(Duration(days: dayBefore)));
    }
  }

  static DateTime _parseData(String strDate) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").parse(strDate);
  }

  static String formatMonthDay(String date) {
    return DateFormat("MM/dd/yyyy").format(DateFormat("MM/dd/yy").parse(date));
  }

  static String currentDateWithddMMyyyyHHss(){
    return DateFormat("dd/MM/yyyy HH:mm:ss a").format(DateTime.now());
  }
}
