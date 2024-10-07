import 'package:dart_ipify/dart_ipify.dart';
import 'package:esmartbazaar/data/repo/aeps_fing_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_fing_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/aeps_rd_service_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../../../model/aeps/aeps_bank.dart';
import '../../../../service/native_call.dart';
import '../../../../util/xml_pid_parser.dart';

class AepsFingEKycController extends GetxController {
  var formOneKey = GlobalKey<FormState>();
  var deviceSerialController = TextEditingController();
  var otpController = TextEditingController();
  var actionTypeObs = EKycActionType.requestOtp.obs;

  late EKycResponse kycResponse;

  AepsBank? selectedAepsBank;
  late List<AepsBank> bankList;
  AepsFingRepo repo = Get.find<AepsFingRepoImpl>();

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

  _showRdServiceDialog() async {
    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchResultForAEPSData(
              {"packageUrl": rdServicePackageUrl, "isTransaction": false});
          var xmlResult = XmlPidParser.parse(result);
          _authKyc(xmlResult);
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

  _authKyc(Map<String, dynamic> data) async {

    if(data["Data"] == ""){
      StatusDialog.alert(title: "Fingerprint didn't capture, please try again");
      return;
    }
    if(data["qScore"] == ""){
      data["qScore"] = "72";
    }
    if(data["ts"] == ""){
      data["ts"] = "2024-09-19T20:47:17+05:30";
    }
    if(data["sysid"] == ""){
      data["sysid"] = "9b1592f299fc8a72";
    }

    Future<Map<String, String>> _params() async => {
          "ipAddress": await Ipify.ipv4(),
          "deviceSerialNumber": deviceSerialController.text.toString(),
          "encodeFPTxnId": kycResponse.encodeFPTxnId ?? "",
          "primaryKeyId": kycResponse.primaryKeyId ?? "",
          "IIN": selectedAepsBank!.id ?? "",
          "bankName": selectedAepsBank!.name ?? "",
          "dc": data["DeviceInfoDC"].toString(),
          "ci": data["SkeyCI"].toString(),
          "hmac": data["Hmac"].toString(),
          "dpID": data["DeviceInfoDpId"].toString(),
          "mc": data["DeviceInfoMC"].toString(),
          "capturesessionKey": data["Skey"].toString(),
          "mi": data["DeviceInfoMI"].toString(),
          "rdsID": data["DeviceInfoRdsId"].toString(),
          "sysid": data["sysid"].toString(),
          "ts": data["ts"].toString(),
          "Piddata": data["Data"].toString(),
          "qScore": data["qScore"].toString(),
          "nmPoints": data["nmPoints"].toString(),
          "PidDatatype": data["DataType"].toString(),
          "rdsVer": data["DeviceInfoRdsVer"].toString()
        };

    var mdata = await _params();

    AppUtil.logger("params : " + mdata.toString());

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
