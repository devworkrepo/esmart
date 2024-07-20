import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/counter_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/dmt/sender_change/change_mobile/sender_change_mobile_controller.dart';

class SenderMobileChangePage extends StatelessWidget {
  const SenderMobileChangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderMobileChangeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Sender Mobile"),
      ),
      body: const SingleChildScrollView(
        child: _ChangeNameForm(),
      ),
    );
  }
}

class _ChangeNameForm extends GetView<SenderMobileChangeController> {
  const _ChangeNameForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          MobileTextField(
                            enable: controller.isMobileTextFieldEnable(),
                            controller: controller.newMobileNumberController,
                            label: "New Mobile Number",
                          ),
                          (controller.actionType.value ==
                                  SenderMobileChangeActionType.changeMobile)
                              ? OtpTextField(
                                  maxLength: 4,
                                  controller: controller.otpController)
                              : const SizedBox(),
                          const SizedBox(
                            height: 16,
                          ),
                          AppButton(
                              text: controller.getButtonText(),
                              onClick: () => controller.onButtonClick()),
                          Obx(() {
                            return (controller.actionType.value ==
                                    SenderMobileChangeActionType.changeMobile)
                                ? Padding(
                              padding: EdgeInsets.only(top: 24,bottom: 8),
                                    child: (controller
                                            .resendButtonVisibilityObs.value)
                                        ? SizedBox(
                                            width: Get.width,
                                            height: 48,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                controller.onResendOtp();
                                              },
                                              child: const Text("Resend Otp"),
                                              style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: Get
                                                          .theme.primaryColor)),
                                            ))
                                        : CounterWidget(
                                            onTimerComplete: () {
                                              controller
                                                  .resendButtonVisibilityObs
                                                  .value = true;
                                            },
                                          ),
                                  )
                                : const SizedBox();
                          })
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
