import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class SenderKycDialog extends StatefulWidget {
  final Function(String) onSubmit;
  const SenderKycDialog(this.onSubmit,{Key? key}) : super(key: key);

  @override
  State<SenderKycDialog> createState() => _SenderKycDialogState();
}

class _SenderKycDialogState extends State<SenderKycDialog> {


  var aadhaarController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseDialogContainer(
       padding: 20,
        backPress: true,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [


                Text("E-KYC",style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/image/aadhaar_ekyc.png',height: 80,width: 80,),
                ),

                Container(
                  padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColor.backgroundColor,
                      borderRadius: BorderRadius.circular(12)

                    ),
                    child: AadhaarTextField(controller: aadhaarController)),
                SizedBox(height: 16,),
                AppButton(text: "Proceed for E-Kyc", onClick: () {
                  if(formKey.currentState!.validate()){
                    widget.onSubmit(aadhaarController.text);
                  }
                })
              ],
            ),
          ),
        ));
  }
}
