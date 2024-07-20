import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/aeps_rd_service_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../../model/aeps/aeps_bank.dart';
import '../../../service/native_call.dart';

class AepsEKycController extends GetxController {
  var formOneKey = GlobalKey<FormState>();
  var deviceSerialController = TextEditingController();
  var otpController = TextEditingController();
  var actionTypeObs = EKycActionType.requestOtp.obs;

  late EKycResponse kycResponse;

  AepsBank? selectedAepsBank;
  late List<AepsBank> bankList;
  AepsRepo repo = Get.find<AepsRepoImpl>();

  @override
  void dispose() {
    deviceSerialController.dispose();
    super.dispose();
  }

  String getButtonText() {
    switch (actionTypeObs.value) {
      case EKycActionType.requestOtp:
        return "Request Otp";
      case EKycActionType.verifyOtp:
        return "Verify Otp";
      case EKycActionType.authKyc:
        return "Complete Kyc";
    }
  }

  void onSubmit() async {
    if (!formOneKey.currentState!.validate()) return;

    switch (actionTypeObs.value) {
      case EKycActionType.requestOtp:
        _requestKycOtp();
        break;
      case EKycActionType.verifyOtp:
        _verifyOtp();
        break;
      case EKycActionType.authKyc:
        _showRdServiceDialog();
        break;
    }
  }

  resendOtp() async {
    if (deviceSerialController.text.isEmpty) {
      showFailureSnackbar(
          title: "Device Serial Number",
          message: "Device serial number is required");
      return true;
    }

    try {
      StatusDialog.progress(title: "Requesting Otp..");
      var response = await repo.eKycResendOtp({
        "ipAddress": await Ipify.ipv4(),
        "deviceSerialNumber": deviceSerialController.text.toString(),
        "encodeFPTxnId": kycResponse.encodeFPTxnId ?? "",
        "primaryKeyId": kycResponse.primaryKeyId ?? "",
      });

      Get.back();

      if (response.code == 1) {
        kycResponse = response;
        showSuccessSnackbar(title: "Resend Otp", message: "Otp has been sent");
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _requestKycOtp() async {
    try {
      StatusDialog.progress(title: "Requesting Otp..");
      var response = await repo.eKycSendOtp({
        "ipAddress": await Ipify.ipv4(),
        "deviceSerialNumber": deviceSerialController.text.toString()
      });

      Get.back();

      if (response.code == 1) {
        kycResponse = response;
        actionTypeObs.value = EKycActionType.verifyOtp;
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _verifyOtp() async {
    try {
      StatusDialog.progress(title: "Verifying Otp");
      var response = await repo.eKycVerifyOtp({
        "ipAddress": await Ipify.ipv4(),
        "deviceSerialNumber": deviceSerialController.text.toString(),
        "encodeFPTxnId": kycResponse.encodeFPTxnId ?? "",
        "primaryKeyId": kycResponse.primaryKeyId ?? "",
        "otp": otpController.text
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message ?? "").then((value) {
          //  actionTypeObs.value = EKycActionType.authKyc;
          _fetchBankList();
        });
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void _fetchBankList() async {
    try {
      StatusDialog.progress(title: "fetching Bank List...");
      var response = await repo.fetchAepsBankList();
      Get.back();

      if (response.code == 1) {
        bankList = response.aepsBankList!;
        actionTypeObs.value = EKycActionType.authKyc;
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _showRdServiceDialog() async{
    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchTramoAepsService(
              {"packageUrl": rdServicePackageUrl, "isTransaction": false});
          _authKyc(result);
        } on PlatformException catch (e) {
          var description =
              "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

          Get.snackbar("Aeps Capture failed", description,
              backgroundColor: Colors.red, colorText: Colors.white);
        } catch (e) {
          Get.dialog(ExceptionPage(error: e));
        }
      },
    ));
  }

  _authKyc(String biometricData) async {
    Future<Map<String,String>> _params() async => {
      "ipAddress": await Ipify.ipv4(),
      "deviceSerialNumber": deviceSerialController.text.toString(),
      "encodeFPTxnId": kycResponse.encodeFPTxnId ?? "",
      "primaryKeyId": kycResponse.primaryKeyId ?? "",
      "IIN": selectedAepsBank!.id ?? "",
      "bankName": selectedAepsBank!.name ??"",
      "biometricData": biometricData
    };

    var mdata = await _params();

    AppUtil.logger("params : "+ mdata.toString());

    try {
      StatusDialog.progress(title: "E-Kyc Authenticating");
      var response = await repo.eKycAuthenticate(await _params());
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}

enum EKycActionType { requestOtp, verifyOtp, authKyc }
