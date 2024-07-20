import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class RefundBottomSheetDialog extends StatefulWidget {

  final Function(String) onProceed;
  const RefundBottomSheetDialog({required this.onProceed,Key? key}) : super(key: key);

  @override
  _RefundBottomSheetDialogState createState() =>
      _RefundBottomSheetDialogState();
}

class _RefundBottomSheetDialogState extends State<RefundBottomSheetDialog> {
  final mpinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key:  _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Take Refund",
                style: Get.textTheme.headline3
                    ?.copyWith(color: Get.theme.primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: MPinTextField(controller: mpinController),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppButton(text: "Proceed", onClick: () {

                  if(_formKey.currentState!.validate()){
                    Get.back();
                    widget.onProceed(mpinController.text);
                  }

                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ReportActionButton extends StatelessWidget {
  final String title ;
  final IconData icon;
  final Color? color;
  final Color? background;
  final VoidCallback onClick;

  const ReportActionButton({required this.title,
    required this.icon,required this.onClick,
    this.color,this.background,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          primary: background ?? Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children:  [
            Icon(
              icon,
              color: color ?? Colors.black,
            ),
            Text(
              title,
              style: TextStyle(color: color ?? Colors.black),
            )
          ],
        ));
  }
}
