import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/util/security/encription.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../widget/common.dart';
import '../../exception_page.dart';

class ChangePinController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var newMPinController = TextEditingController();
  var confirmMPinController = TextEditingController();
  var otpController = TextEditingController();

  var changePinActionTypeObs = ChangePinActionType.requestOtp.obs;

  var formKey = GlobalKey<FormState>();

  var resendButtonVisibilityObs = false.obs;

  requestOtp() async {
    try {
      StatusDialog.progress(title: "Generating Otp");
      var response = await repo.requestOtp({"otptype": "mpin"});
      Get.back();
      if (response.code == 1) {
        changePinActionTypeObs.value = ChangePinActionType.changePin;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  verifyOtp() async {
    try {
      StatusDialog.progress(title: "Verifying");
      var response = await repo.changePin({
        "newpin": Encryption.aesEncrypt(newMPinController.text),
        "otp": otpController.text,
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) {
              if(Get.isSnackbarOpen){
                Get.closeAllSnackbars();
                Get.back();
              }
              else{
                Get.back();
              }
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  resendOtp() async {
    try {
      StatusDialog.progress();

      var response = await repo.requestOtp({"otptype": "mpin"});
      Get.back();

      if (response.code == 1) {

        showSuccessSnackbar(title: "Resent Otp", message: response.message);
        resendButtonVisibilityObs.value = false;
      } else {
        showFailureSnackbar(title: "Resent Otp", message: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}

enum ChangePinActionType{
  requestOtp, changePin
}