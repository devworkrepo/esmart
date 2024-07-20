import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/common/counter_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/util/mixin/dialog_helper_mixin.dart';
import 'package:dio/dio.dart' as dio;

class OtpDialogWidget extends GetView<_ResendOtpController>
    with DialogHelperMixin {
  final Function(String) onSubmit;
  final int maxLength;
  final String? message;
  final String? resendOtpUrl;
  final Map<String,dynamic>? param;
  final String method;

  OtpDialogWidget(
      {Key? key,
      required this.onSubmit,
      this.maxLength = 4,
      this.message,
      this.param,
      this.method = "get",
      this.resendOtpUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(_ResendOtpController());
    controller.url = resendOtpUrl ?? "";
    controller.method = method;
    controller.param = param;

    return buildBaseContainer(
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                Text(
                  message != null
                      ? message!
                      : "OTP (one time password) has sent to your registered mobile number. Please check inbox",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      height: 1.5),
                ),
                const SizedBox(
                  height: 8,
                ),
                OtpTextField(
                  controller: controller.otpController,
                  maxLength: maxLength,
                ),
                const SizedBox(
                  height: 24,
                ),
                AppButton(
                    text: "Submit",
                    onClick: () {
                      if (controller.formKey.currentState!.validate()) {
                        Get.back();
                        onSubmit(controller.otpController.text.toString());
                      }
                    }),
                const SizedBox(
                  height: 32,
                ),
                (resendOtpUrl == null) ? const SizedBox() : _buildResendWidget()
              ],
            ),
          ),
        ),
        title: "OTP");
  }

  _buildResendWidget() {
    return Obx(() => (controller.resendingObs.value)
        ? const CircularProgressIndicator()
        : (controller.resendButtonVisibilityObs.value)
            ? SizedBox(
                width: Get.width,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    controller.resendOtp(resendOtpUrl ?? "");
                  },
                  child: const Text("Resend Otp"),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Get.theme.primaryColor)),
                ))
            : CounterWidget(
                onTimerComplete: () {
                  controller.resendButtonVisibilityObs.value = true;
                },
              ));
  }
}

class _ResendOtpController extends GetxController {
  late String method;
  late String url;
  late Map<String,dynamic>? param;

  var resendButtonVisibilityObs = false.obs;
  var resendingObs = false.obs;

  var otpController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  NetworkClient client = Get.find();

  resendOtp(String url) async {

    dio.Response<dynamic> responseBody;

    try {
      resendingObs.value = true;
      if(method == "post"){
       responseBody = await client.post(url,data: param);
      }
      else{
        responseBody = await client.get(url,queryParameters: param);
      }

      var response = StatusMessageResponse.fromJson(responseBody.data);
      resendingObs.value =false;
      if (response.status == 1) {
        resendButtonVisibilityObs.value = false;
        showSuccessSnackbar(
            title: "Resend Otp Success", message: response.message);
      } else {
        showFailureSnackbar(
            title: "Resend Otp Failed", message: response.message);
      }
    } catch (e) {
      resendingObs.value = false;
      showFailureSnackbar(title: "Failed Resend Otp", message: e.toString());
    }
  }
}
