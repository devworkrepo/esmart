import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';

import '../../../model/dmt/sender_info.dart';

class SenderAddController2 extends GetxController {

  DmtRepo repo = Get.find<DmtRepoImpl>();

  GlobalKey<FormState> senderAddFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();


  SenderInfo? sender = Get.arguments["sender"];
  String mobile  = Get.arguments["mobile"];

  var remitterid = "";
  var ekycid = "";
  var ekyccode = "";



  @override
  void onInit() {
    super.onInit();
    mobileNumberController.text = mobile;
    firstNameController.text = sender?.first_name ?? "";
    lastNameController.text = sender?.last_name ?? "";
  }



  requestOtp() async {
    try {
      StatusDialog.progress();
      var response = await repo.senderRegistration2({
        "mobileno": mobileNumberController.text.toString(),
        "remitterid": sender?.senderId ?? "",
      });
      Get.back();
      if (response.code == 1) {

         remitterid = response.remitterid ?? "";
         ekycid = response.ekycid ?? "";
         ekyccode = response.ekyccode ?? "";
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

      var response = await repo.senderRegistrationOtp2({
        "remitterid": remitterid,
        "mobileno": mobileNumberController.text.toString(),
        "otp": otpController.text.toString(),
        "fname" : firstNameController.text.toString(),
        "lname" : firstNameController.text.toString(),
        "otp" : otpController.text.toString(),
        "ekycid" :ekycid,
        "ekyccode" :ekyccode
      });

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) => Get.back(result: {
          "mobile_number" : mobileNumberController.text
        }));
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
    mobileNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

enum SenderAddActionType { requestOtp, addSender }