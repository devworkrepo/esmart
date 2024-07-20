import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/aeps/aeps_e_kyc/aeps_e_kyc_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../widget/drop_down.dart';
import '../../../util/input_validator.dart';

class AepsEKycPage extends GetView<AepsEKycController> {
  const AepsEKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsEKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-KYC"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [_BuildStepOneForm()],
          ),
        ),
      ),
    );
  }
}

class _BuildStepOneForm extends GetView<AepsEKycController> {
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
                    (controller.actionTypeObs.value == EKycActionType.authKyc)
                        ? "Final Setup"
                        : "Initial Setup",
                    style: Get.textTheme.headline6,
                  ),
                  ConditionalWidget(
                      condition: controller.actionTypeObs.value !=
                          EKycActionType.authKyc,
                      child: Column(
                        children: [
                          AppTextField(
                            label: "Device Serial Number",
                            hint: "Required*",
                            validator: FormValidatorHelper.normalValidation,
                            controller: controller.deviceSerialController,
                          ),
                          ConditionalWidget(
                              condition: controller.actionTypeObs.value !=
                                  EKycActionType.requestOtp,
                              child: OtpTextField(
                                controller: controller.otpController,
                                maxLength: 7,
                              )),
                        ],
                      )),


                  (controller.actionTypeObs.value == EKycActionType.authKyc)
                      ? AppDropDown(
                    maxHeight: Get.height * 0.75,
                    list: List.from(controller.bankList.map((e) => e.name)),
                    onChange: (value) {
                      try {
                        controller.selectedAepsBank = controller.bankList
                            .firstWhere((element) => element.name == value);
                      } catch (e) {
                        controller.selectedAepsBank = null;
                        Get.snackbar("Bank is not selected",
                            "Exception raised while selecting bank",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    validator: (value) {
                      if (controller.selectedAepsBank == null) {
                        return "Select bank";
                      } else {
                        return null;
                      }
                    },
                    searchMode: true,
                    label: "Select Bank",
                    hint: "Select Bank",
                  )
                      : SizedBox(),


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
                          EKycActionType.verifyOtp,
                      child: AppButton(
                          background: Colors.red,
                          text: "Resend Otp",
                          onClick: controller.resendOtp))
                ],
              )),
        ),
      ),
    );
  }
}
