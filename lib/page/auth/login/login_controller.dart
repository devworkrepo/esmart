import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/auth_repo.dart';
import 'package:esmartbazaar/data/repo_impl/auth_impl.dart';
import 'package:esmartbazaar/model/user/login.dart';
import 'package:esmartbazaar/page/auth/login/login_tac_dialog.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/security/app_config.dart';
import 'package:esmartbazaar/util/security/encription.dart';

import '../../../service/native_call.dart';
import '../../../util/api/exception.dart';
import '../../../util/app_constant.dart';
import '../../../util/mixin/location_helper_mixin.dart';

class LoginController extends GetxController with LocationHelperMixin {
  AuthRepo authRepo = Get.find<AuthRepoImpl>();
  AppPreference appPreference = Get.find();

  var loginFormKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();

  var isLoginCheck = false.obs;
  var saveLoginInfo = false;

  @override
  void onInit() {
    super.onInit();
    saveLoginInfo = !appPreference.isBiometricAuthentication;
    appPreference.setIsTransactionApi(false);
    appPreference.setSessionKey("na");
    isLoginCheck.value = appPreference.isLoginCheck;

    if (appPreference.isLoginCheck && saveLoginInfo) {
      mobileController.text = appPreference.mobileNumber;
      passwordController.text = appPreference.password;
    }

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (!appPreference.isLoginBondAccepted) {
        Get.dialog(LoginTermAndConditionDialog(onAccept: () async {
          await appPreference.setIsLoginBondAccepted(true);
        }, onReject: () async {
          await appPreference.setIsLoginBondAccepted(false);
        }));
      }

      validateLocation(progress: false);
    });
  }

  login({bool subRetailerLogin = false}) async {
    appPreference.logout();
    var isValidate = loginFormKey.currentState?.validate();
    if (!isValidate!) return;

    if (position == null) {
      await validateLocation();
      if (position == null) return;
    }

    if (!appPreference.isLoginBondAccepted) {
      Get.dialog(LoginTermAndConditionDialog(onAccept: () async {
        await appPreference.setIsLoginBondAccepted(true);
        login();
      }, onReject: () async {
        await appPreference.setIsLoginBondAccepted(false);
      }));
      return;
    }

    StatusDialog.progress(title: "Login");

    final mobileNumber = mobileController.text.toString();
    final password = Encryption.aesEncrypt(passwordController.text.toString());

    try {
      final loginData = {
        "mobileno": mobileNumber,
        "password": password,
        "dvckey": await AppUtil.getDeviceID(),
        "appid": AppConfig.apiCode,
        "accesskey": AppConfig.apiKey
      };

      // todo AppUtil.throwUatExceptionOnDeployment(mobileController.text);

      AppUtil.logger(loginData.toString());
      LoginResponse login = (subRetailerLogin)
          ? await authRepo.subAgentLogin(loginData)
          : await authRepo.agentLogin(loginData);
      Get.back();

      if (login.code == 1) {
        Get.toNamed(AppRoute.loginOtpPage, parameters: {
          "mobileNumber": mobileController.text.toString(),
          "isLoginChecked": isLoginCheck.value.toString(),
          "password": passwordController.text.toString(),
          "loginData": json.encode(login.toJson())
        });
      } else {
        StatusDialog.failure(title: login.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}
