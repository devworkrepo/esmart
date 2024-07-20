import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/exception_page.dart';

class SenderMobileChangeController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();
  SenderInfo senderInfo = Get.arguments["sender"];

  var newMobileNumberController = TextEditingController();
  var otpController = TextEditingController();

  var resendButtonVisibilityObs = false.obs;
  var actionType = SenderMobileChangeActionType.requestOtp.obs;

  var formKey = GlobalKey<FormState>();

  onButtonClick() {
    if (actionType.value == SenderMobileChangeActionType.requestOtp) {
      _onRequestOtp();
    } else {
      _onMobileChange();
    }
  }

  onResendOtp() {
    _onRequestOtp();
  }

  _onRequestOtp() async {
    if (actionType.value !=
        SenderMobileChangeActionType.changeMobile) {
      if (!formKey.currentState!.validate()) {
        return;
      }
    }

    try {
      StatusDialog.progress();

      var response = await repo.changeSenderOtp({
        "name": senderInfo.senderName.toString(),
        "current_mobileno": senderInfo.senderNumber.toString(),
        "new_mobileno": newMobileNumberController.text,
      });

      Get.back();
      if (response.code == 1) {
        actionType.value = SenderMobileChangeActionType.changeMobile;
        resendButtonVisibilityObs.value = false;
        showSuccessSnackbar(
            title: "Sender Change Otp", message: response.message);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _onMobileChange() async {
    if (!formKey.currentState!.validate()) return;
    var senderNumber = newMobileNumberController.text.toString();

    try {
      StatusDialog.progress();
      var response = await repo.changeSenderMobile({

        "remitterid": senderInfo.senderId.toString(),
        "new_mobileno":senderNumber,
        "otp": otpController.text.toString(),
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) =>
            Get.back(result: newMobileNumberController.text.toString()));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  String getButtonText() {
    return (actionType.value == SenderMobileChangeActionType.requestOtp)
        ? "Request Otp"
        : "Change Number";
  }

  bool isMobileTextFieldEnable() {
    return actionType.value == SenderMobileChangeActionType.requestOtp;
  }

  @override
  void dispose() {
    newMobileNumberController.dispose();
    super.dispose();
  }
}

enum SenderMobileChangeActionType { requestOtp, changeMobile }
