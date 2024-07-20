import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExceptionWidget extends StatelessWidget {
  final Exception exception;

  const ExceptionWidget(this.exception, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        exception.toString(),
        textAlign: TextAlign.center,
        style: Get.textTheme.subtitle1?.copyWith(color: Colors.red),
      ),
    );
  }
}
