import 'dart:convert';

import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';

import '../../../model/dmt/sender_info.dart';
import '../../../service/native_call.dart';
import '../../../util/xml_pid_parser.dart';
import '../../../widget/dialog/aeps_rd_service_dialog.dart';

class SenderAddController3 extends GetxController with TransactionHelperMixin {

  DmtRepo repo = Get.find<DmtRepoImpl>();
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();

  GlobalKey<FormState> senderAddFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var aadhaarNumberController = TextEditingController();
  var otpController = TextEditingController();


  SenderInfo? sender = Get.arguments["sender"];
  String mobile  = Get.arguments["mobile"];


  String otpcode = "";
  var isEkycPage = false.obs;
  var verifycode = "";


  @override
  void onInit() {
    super.onInit();
    mobileNumberController.text = mobile;
    aadhaarNumberController.text = sender?.first_name ?? "";
  }



  requestOtp() async {
    try {
      StatusDialog.progress();
      var response = await repo.senderRegistration3({
        "mobileno": mobileNumberController.text.toString(),
        "tokencode": sender?.tokencode ?? "",
        "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
      });
      Get.back();
      if (response.code == 1) {
        otpcode = response.otpcode ?? "";
        showSuccessSnackbar(
            title: "Remitter Add Otp", message: response.message);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  senderRegistration() async {
    final isValidate = senderAddFormKey.currentState!.validate();
    if (!isValidate) return;

    try {
      StatusDialog.progress();

      var response = await repo.senderRegistrationOtp3({
        "otpcode": otpcode,
        "mobileno": mobileNumberController.text.toString(),
        "otp": otpController.text.toString()
      });

      Get.back();

      if (response.code == 1) {
        verifycode = response.verifycode ?? "";
        StatusDialog.success(title: response.message).then((value) => isEkycPage.value = true);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  captureFingerprint() {


    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchResultForAEPSData(
              {"packageUrl": rdServicePackageUrl, "isTransaction": false});
          var xmlResult = XmlPidParser.parse(result);
          _onRdServiceResult(xmlResult);

        } on PlatformException catch (e) {
          var description =
              "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

          Get.snackbar("Aeps Capture failed", description,
              backgroundColor: Colors.red, colorText: Colors.white);
        } catch (e) {
          Get.dialog(ExceptionPage(error: e));
        }
      },
    ),);

  }

  _onRdServiceResult(Map<String,String> data) async {


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



    StatusDialog.progress();

    final mResponse = await homeRepo.getTransactionNumber();
    final transactionNumber =  mResponse.transactionNumber;

    final authParams = {
      "mobileno" : mobile,
      "lat": "12.2342",
      "lng": "92.12321",
      "transno" : transactionNumber.toString(),
      "ci": data["SkeyCI"].toString(),
      "hmac": data["Hmac"].toString(),
      "piddata" : data["Data"].toString(),
      "pidts" : data["ts"].toString(),
      "dc": data["DeviceInfoDC"].toString(),
      "mi": data["DeviceInfoMI"].toString(),
      "dpid" : data["DeviceInfoDpId"].toString(),
      "mc": data["DeviceInfoMC"].toString(),
      "rdsid" :  data["DeviceInfoRdsId"].toString(),
      "rdsver" : data["DeviceInfoRdsVer"].toString(),
      "srno" : data["srno"].toString(),
      "skey" : data["Skey"].toString(),
      "verifytoken" : verifycode,
    };

    try{
      var response = await repo.senderRegistrationKycDmt3(authParams);

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          Get.back(result: {"mobile_number": mobile});
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    }catch(e){
      Get.back();
      final formattedAuthParams = const JsonEncoder.withIndent('  ').convert(authParams);
      StatusDialog.alert(title: formattedAuthParams);
    }
  }


  @override
  void dispose() {
    mobileNumberController.dispose();
    aadhaarNumberController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

enum SenderAddActionType { requestOtp, addSender }