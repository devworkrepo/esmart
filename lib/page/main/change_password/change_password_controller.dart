import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/security/encription.dart';

import '../../exception_page.dart';

class ChangePasswordController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var otpController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var resendButtonVisibilityObs = false.obs;

  var changePasswordActionTypeObs = ChangePasswordActionType.requestOtp.obs;
  AppPreference appPreference = Get.find();

  requestOtp() async {
    try {
      StatusDialog.progress(title: "Generating Otp");
      var response = await repo.requestOtp({"otptype": "password"});
      Get.back();
      if (response.code == 1) {
        showSuccessSnackbar(title: "Otp Sent", message: response.message);
        changePasswordActionTypeObs.value =
            ChangePasswordActionType.changePassword;
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

      var response = await repo.requestOtp({"otptype": "password"});
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

  changePassword() async {
    try {
      StatusDialog.progress(title: "Progressing");
      var response = await repo.changePassword({
        "currentpassword": Encryption.aesEncrypt(oldPasswordController.text),
        "newpassword": Encryption.aesEncrypt(newPasswordController.text),
        "otp": otpController.text.toString(),
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          appPreference.logout();
          Get.offAllNamed(AppRoute.loginPage);
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

enum ChangePasswordActionType { requestOtp, changePassword }
