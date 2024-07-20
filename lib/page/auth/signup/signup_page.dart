import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/auth/signup/signup_controller.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_7_upload_doc.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_3_captcha_verify.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_4_aadhaar_verify.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_1_contact_detail.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_6_pan_verification.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_5_aadhaar_detail.dart';
import 'package:esmartbazaar/page/auth/signup/step/step_2_mobile_verify.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/obx_widget.dart';


class SignupPage extends GetView<SignupController> {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Sign Up"),
        ),
        body: ObsResourceWidget(
          obs: controller.stateListResponse, childBuilder: (data) =>
            WillPopScope(
              onWillPop: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Sign Up'),
                      content: Text('Sign up is incompleted!',
                        style: Get.textTheme.subtitle2,),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            Get.offAllNamed(AppRoute.loginPage);
                          },
                          child: Text('Go Back'),
                        ),
                      ],
                    );
                  },
                );
                return false;
              },
              child: Obx(() {
                return Stepper(
                  elevation: 1,
                  onStepTapped: (value) {

                  },
                  currentStep: controller.stepperCurrentIndex.value,
                  onStepContinue: controller.onContinue,
                  onStepCancel: () {},
                  controlsBuilder: (BuildContext context,
                      ControlsDetails details) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() {
                        return (controller.proceedButtonText.value.isEmpty)
                            ? const SizedBox()
                            : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green),
                          onPressed: () {
                            controller.onContinue();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(controller.proceedButtonText.value),
                              if (controller.stepperCurrentIndex.value != 6)
                                const Icon(Icons.chevron_right_outlined)
                            ],
                          ),
                        );
                      }),
                    );
                  },
                  type: StepperType.horizontal,
                  steps: [
                    Step(
                        state: controller.stepContactDetail.value,
                        isActive: controller.isStepperActive(0),
                        title: const Text(""),
                        content: const StepContactDetail()),
                    Step(
                        state: controller.stepMobileVerify.value,
                        isActive: controller.isStepperActive(1),
                        title: const Text(""),
                        content: const StepMobileVerify()),
                    Step(
                        state: controller.stepCaptchaVerify.value,
                        isActive: controller.isStepperActive(2),
                        title: const Text(""),
                        content: const StepCaptchaVerify()),
                    Step(
                        state: controller.stepAadhaarVerify.value,
                        isActive: controller.isStepperActive(3),
                        title: const Text(""),
                        content: const StepAadhaarVerify()),
                    Step(
                        state: controller.stepAadhaarDetail.value,
                        isActive: controller.isStepperActive(4),
                        title: const Text(""),
                        content: const StepAadhaarDetail()),
                    Step(
                        state: controller.stepPanVerification.value,
                        isActive: controller.isStepperActive(5),
                        title: const Text(""),
                        content: const StepPanVerification()),
                    Step(
                        state: controller.stepUploadDoc.value,
                        isActive: controller.isStepperActive(6),
                        title: const Text(""),
                        content: const StepUploadDoc()),
                  ],
                );
              }),
            ),
        )
    );
  }
}
