import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

import '../../../widget/common.dart';
import '../../../model/dmt/sender_kyc.dart';

class SenderKycController extends GetxController with TransactionHelperMixin {
  DmtRepo repo = Get.find<DmtRepoImpl>();
  String mobileNumber = Get.arguments["mobile_number"];
  DmtType dmtType = Get.arguments["dmt_type"];

  var aadhaarController = TextEditingController();
  var initialFormKey = GlobalKey<FormState>();


  var finalFormKey = GlobalKey<FormState>();
  var otpController = TextEditingController();

  var actionTypeObs = SenderKycActionType.initialStep.obs;

  var resendButtonVisibilityObs = false.obs;

  var refId = "";


  onRequestOtp() async {
    if (!initialFormKey.currentState!.validate()) return;

    StatusDialog.progress();
    try {
      var response = await repo.senderKycSendOtp({
        "mobileno": mobileNumber,
        "aadharno": aadhaarWithoutSymbol(aadhaarController),

      });
      Get.back();
      if (response.code == 1) {
        refId = response.refid ?? "";
        actionTypeObs.value = SenderKycActionType.finalStep;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }


  resendOtp() async {

    StatusDialog.progress();
    try {
      var response = await repo.senderKycSendOtp({
        "mobileno": mobileNumber,
        "aadharno": aadhaarWithoutSymbol(aadhaarController),

      });
      Get.back();
      if (response.code == 1) {
        refId = response.refid ?? "";
        StatusDialog.success(title: response.message);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }



  verifyOtp() async {


    if(!finalFormKey.currentState!.validate())return;

    StatusDialog.progress();

    try {
      var response = await repo.senderKycVerifyOtp({
        "mobileno": mobileNumber,
        "aadharno": aadhaarWithoutSymbol(aadhaarController),
        "otp" : otpController.text,
        "refid" : refId
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          Get.toNamed(AppRoute.senderKycInfoPage,arguments: {
            "mobile_number" : mobileNumber,
            "dmt_type" : dmtType,
            "from_kyc" : true,
          });
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }



  onReset() {
    aadhaarController.text = "";
    actionTypeObs.value = SenderKycActionType.initialStep;


  }

  @override
  void dispose() {
    aadhaarController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

enum SenderKycActionType { initialStep, finalStep }
