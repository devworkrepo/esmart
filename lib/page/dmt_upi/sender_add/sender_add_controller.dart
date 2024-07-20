
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/page/exception_page.dart';

class UpiSenderAddController extends GetxController {

  UpiRepo repo = Get.find<UpiRepoImpl>();

  GlobalKey<FormState> senderAddFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();


  var actionType = SenderAddActionType.requestOtp.obs;


  onButtonClick() {
    if (actionType.value == SenderAddActionType.requestOtp) {
      _senderRegistrationRequestOtp();
    } else {
      _senderRegistrationVerifyOtp();
    }
  }

  onResendOtp() {
    _senderRegistrationRequestOtp();
  }

  @override
  void onInit() {
    super.onInit();
    final isRegistered = Get.arguments["isRegistered"];
    actionType.value = (isRegistered) ? SenderAddActionType.addSender: SenderAddActionType.requestOtp;
    mobileNumberController.text = Get.arguments["mobile"];

  }

  _senderRegistrationRequestOtp() async {
    if (actionType.value != SenderAddActionType.addSender) {
      if (!senderAddFormKey.currentState!.validate()) {
        return;
      }
    }


    try {
      StatusDialog.progress();

      var response = await repo.senderRegistration({
        "mobileno": mobileNumberController.text.toString(),
        "fname": firstNameController.text.toString(),
        "lname": lastNameController.text.toString(),
      });

      Get.back();

      if (response.code == 1) {
        actionType.value = SenderAddActionType.addSender;
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

  _senderRegistrationVerifyOtp() async {
    final isValidate = senderAddFormKey.currentState!.validate();
    if (!isValidate) return;


    try {
      StatusDialog.progress();

      var response = await repo.senderRegistrationOtp({
        "mobileno": mobileNumberController.text.toString(),
        "otp": otpController.text.toString(),
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

  String getButtonText() {
    return (actionType.value == SenderAddActionType.requestOtp)
        ? "Request Otp"
        : "Register Remitter";
  }

  bool isTextFieldEnable() {
    return actionType.value == SenderAddActionType.requestOtp;
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