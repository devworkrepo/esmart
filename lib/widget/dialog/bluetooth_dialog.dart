import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class BluetoothDialog extends StatelessWidget {
  const BluetoothDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialogContainer(
        padding: 10,
        backPress: true,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bluetooth,
                      size: 60,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Device is not paired with machine via bluetooth",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.subtitle1,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(

                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Step 1",
                            style: Get.textTheme.headline5?.copyWith(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          Text(
                            "Please go to bluetooth setting and paired it manually. Bluetooth device name should be start with VM and end with Android keyword.\n eg. VM301456789_Android",
                            style: TextStyle(
                                height: 1.5, color: Colors.grey[600]!),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "eg. VM301456789_Android",
                            style: TextStyle(
                                height: 1.5,
                                color: Get.theme.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          "Step 2 (If Appear)",
                          style: Get.textTheme.headline5?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        SizedBox(height: 16,),
                        Image.asset(
                          "assets/image/mpos_hint.jpg",
                          height: 176,
                          width: Get.width,
                        )
                      ],),
                    ),
                  ],
                ),
              )),
              SizedBox(
                height: 16,
              ),
              AppButton(
                  text: "Go to Setting",
                  onClick: () {
                    AppSettings.openBluetoothSettings();
                    Get.back();
                  })
            ],
          ),
        ));
  }
}
