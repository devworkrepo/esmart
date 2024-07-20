import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/dmt/sender_kcy/sender_kyc_controller.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../widget/common/counter_widget.dart';
import '../../../util/app_constant.dart';

class SenderKycPage extends GetView<SenderKycController> {
  const SenderKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sender Kyc"),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            const _BuildHeaderTitleWidget(),
            Obx(() => controller.actionTypeObs.value ==
                SenderKycActionType.initialStep
                ? const _BuildAadhaarAndCaptchaWidget()
                : const SizedBox()),
            Obx(() => controller.actionTypeObs.value ==
                SenderKycActionType.finalStep
                ? const _BuildOtpWidget()
                : const SizedBox()),
          ],
        ),
      )
    );
  }
}

class _BuildOtpWidget extends GetView<SenderKycController> {
  const _BuildOtpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.backgroundColor,
                ),
                child: const Text(
                  "Verification otp  as sent to remitter mobile number!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                  key: controller.finalFormKey,
                  child: Column(
                    children: [
                      OtpTextField(
                        controller: controller.otpController,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      AppButton(
                          width: 200,
                          isRounded: true,
                          text: "Verify Otp",
                          onClick: () => controller.verifyOtp()),
                      const SizedBox(height: 24),
                      Obx(() {
                        return (controller.resendButtonVisibilityObs.value)
                            ? SizedBox(
                                width: 200,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    controller.resendOtp();
                                  },
                                  child: const Text("Resend Otp"),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100.0),
                                              side: const BorderSide(
                                                  color: Colors.red)))),
                                ))
                            : CounterWidget(
                                onTimerComplete: () {
                                  controller.resendButtonVisibilityObs.value =
                                      true;
                                },
                              );
                      })
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildAadhaarAndCaptchaWidget extends GetView<SenderKycController> {
  const _BuildAadhaarAndCaptchaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.initialFormKey,
            child: Column(
              children: [
                AadhaarTextField(controller: controller.aadhaarController),


                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    Expanded(
                        child: AppButton(
                            text: "Send Otp",
                            onClick: () => controller.onRequestOtp())),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                        child: AppButton(
                      text: "Reset",
                      onClick: () => controller.onReset(),
                      background: Colors.red,
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildHeaderTitleWidget extends StatelessWidget {
  const _BuildHeaderTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Get.theme.primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              AppCircleAssetPng("assets/image/otp_icon.png"),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "OTP Based Aadhar EKYC Authentication",
                      style: Get.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Simply Enter you OTP as received on your aadhar registered mobile no and complete your eKYC.",
                      style: Get.textTheme.bodyText1
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
