import 'package:esmartbazaar/page/dmt/sender_add_3/sender_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class SenderAddPage3 extends GetView<SenderAddController3> {
  const SenderAddPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderAddController3());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Sender - DMT 3"),
      ),
      body: Obx(()=> (controller.isEkycPage.value) ?
      _buildBiometricUI() :
      _buildSenderAddForm()),
    );
  }

  _buildSenderAddForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.senderAddFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MobileTextField(
                      enable: false,
                      controller: controller.mobileNumberController),
                    AadhaarTextField(
                        controller: controller.aadhaarNumberController),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: OtpTextField(
                              maxLength: 6,
                              controller: controller.otpController,
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: 100,
                            child: AppButton(
                                text: "Send Otp",
                                onClick: () =>
                                    controller.requestOtp()))
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                    text: "Register Remitter",
                    onClick: () => controller.senderRegistration(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    );
  }
}