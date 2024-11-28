import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sender_add_kyc_controller.dart';

class SenderAddKycPage extends GetView<SenderAddKycController> {
  const SenderAddKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderAddKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Remitter KyC"),
      ),
      body: _buildBiometricUI()

    );
  }

  _buildBiometricUI() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.all(16),
                        child:  Image.asset(
                          "assets/image/ekyc_person.png",
                          height: 100,
                        )),
                    const SizedBox(
                      height: 20,
                    ),

                    AadhaarTextField(controller: controller.aadhaarController),
                    const SizedBox(height: 12,),
                    AppButton(
                        text: "Capture and Proceed Kyc",
                        onClick: () =>controller.captureFingerprint(),
                     ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
