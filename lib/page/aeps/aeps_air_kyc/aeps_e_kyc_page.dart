import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/aeps/aeps_air_kyc/aeps_e_kyc_controller.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

class AepsAirEKycPage extends GetView<AepsAirKycController> {
  const AepsAirEKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsAirKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Aeps Token"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: const [_BuildStepOneForm()],
          ),
        ),
      ),
    );
  }
}

class _BuildStepOneForm extends GetView<AepsAirKycController> {
  const _BuildStepOneForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formOneKey,
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (controller.actionTypeObs.value ==
                            AepsAirKycActionType.verifyBiometric)
                        ? "Capture Biometric Data"
                        : "Verify Otp",
                    style: Get.textTheme.headline6,
                  ),
                  ConditionalWidget(
                      condition: controller.actionTypeObs.value ==
                          AepsAirKycActionType.verifyOtp,
                      child: OtpTextField(
                        controller: controller.otpController,
                        maxLength: 6,
                      )),
                  ConditionalWidget(
                      condition: controller.actionTypeObs.value ==
                          AepsAirKycActionType.verifyBiometric,
                      child: AadhaarTextField(
                          controller: controller.aadhaarController)),

                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                      text: controller.getButtonText(),
                      onClick: controller.onSubmit),
                  const SizedBox(
                    height: 16,
                  ),
                  ConditionalWidget(
                      condition: controller.actionTypeObs.value ==
                          AepsAirKycActionType.verifyOtp,
                      child: AppButton(
                          background: Colors.red,
                          text: "Resend Otp",
                          onClick: controller.requestOtp))
                ],
              )),
        ),
      ),
    );
  }
}
