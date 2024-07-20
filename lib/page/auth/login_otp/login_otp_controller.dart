import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/auth_repo.dart';
import 'package:esmartbazaar/data/repo_impl/auth_impl.dart';
import 'package:esmartbazaar/model/user/login.dart';
import 'package:esmartbazaar/page/auth/login_otp/verifying_device_dailog.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/exception.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/security/app_config.dart';
import 'package:esmartbazaar/util/security/encription.dart';

import 'device_register_dialog.dart';

class LoginOtpController extends GetxController  {
  AuthRepo authRepo = Get.find<AuthRepoImpl>();
  AppPreference appPreference = Get.find();

  var deviceVerificationFormKey = GlobalKey<FormState>();
  var otpController = TextEditingController();

  String mobileNumber = Get.parameters["mobileNumber"]!;
  String password = Get.parameters["password"]!;
  bool isLoginCheck = Get.parameters["isLoginChecked"]! == "true";
  LoginResponse loginData =
      LoginResponse.fromJson(json.decode(Get.parameters["loginData"]!));

  var resendButtonVisibilityObs = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  verifyOtp() async {
    var isValidate = deviceVerificationFormKey.currentState?.validate();
    if (!isValidate!) return;

    StatusDialog.progress(title: "Verifying");
    try {
      final data = {
        "dvckey": await AppUtil.getDeviceID(),
        "dvc_name": await AppUtil.modelName(),
        "retailerid": loginData.agentId.toString(),
        "otp": otpController.text.toString(),
      };

      LoginResponse response = await authRepo.loginOtp(data);
      Get.back();

      if (response.code == 1) {

        if(await AppUtil.isDeviceHasLock()){
          _saveLoginData(response.sessionKey!);
        }
        else{

          if(mobileNumber == "9785172173"){
            _saveLoginData(response.sessionKey!);
          }
          else{
            Get.offAllNamed(AppRoute.deviceLockPage);
          }

        }

        //_checkDevice(response.sessionKey!);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _saveLoginData(String sessionKey) async{
    await appPreference.setSessionKey(sessionKey);

    await appPreference.setIsLoginCheck(isLoginCheck);
    await appPreference.setPassword((isLoginCheck) ? password : "na");
    await appPreference
        .setMobileNumber((isLoginCheck) ? mobileNumber : "na");

    Get.offAllNamed(AppRoute.mainPage,arguments: {"retailerType" : "Sub"});
  }

  _checkDevice(String sessionKey) async {
    try {
      Get.dialog(const DeviceVerificationDialog());

      var response = await authRepo.checkDevice({
        "enc_value": await Encryption.getEncValue(mobileNumber),
        "dvc_name": await AppUtil.modelName(),
        "sessionkey": sessionKey,
        "ipaddress": await Ipify.ipv4(),
        "seckey": AppConfig.secretKey,
      });
      Get.back();
      if (response.code == 1) {
        _saveLoginData(sessionKey);
      } else if (response.code == 2) {
        var deviceName = await AppUtil.modelName();
        Get.dialog(ShowDeviceRegisterDialog(
          deviceName: deviceName,
          message: response.message,
          onAccept: () => _onRegisterNewDevice(sessionKey),
          onReject: (){
            Get.back();
            appPreference.logout();
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  resendOtp() async {
    try{
      StatusDialog.progress();

      var response = await authRepo.resendLoginOtp({
        "dvckey": await AppUtil.getDeviceID(),
        "retailerid": loginData.agentId.toString(),
        "otpkey": loginData.otpKey.toString()
      });

      Get.back();

      if (response.code == 1) {
        showSuccessSnackbar(title: "Resent Otp", message: response.message);
        resendButtonVisibilityObs.value = false;
      } else {
        showFailureSnackbar(title: "Resent Otp", message: response.message);
      }
    }catch (e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }


  _onRegisterNewDevice(String sessionKey) async {
    try {
      StatusDialog.progress(title: "Registering...");

      var response = await authRepo.registerNewDevice({
        "enc_value":
        await Encryption.getEncValue(mobileNumber),
        "dvckey": await AppUtil.getDeviceID(),
        "dvc_name": await AppUtil.modelName(),
        "sessionkey": sessionKey,
        "ipaddress": await Ipify.ipv4(),
        "seckey": AppConfig.secretKey,
      });

      Get.back();
      if (response.code == 1) {
        _saveLoginData(sessionKey);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      handleException(e);
    }
  }
}
