import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCheckBox extends StatefulWidget {
  final bool value;
  final String title;
  final Function(bool) onChange;

  const AppCheckBox(
      {required this.value,
      required this.onChange,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  var isLoginCheck = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoginCheck = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: isLoginCheck,
            onChanged: (value) {
              widget.onChange(value!);
              setState(() {
                isLoginCheck = value;
              });
            }),
        Expanded(child: Text(widget.title,style: Get.textTheme.caption?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14
        ),))
      ],
    );
  }
}
