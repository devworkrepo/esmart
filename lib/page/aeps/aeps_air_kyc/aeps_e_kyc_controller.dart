import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/aeps_aitel_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_aitel_impl.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/widget/dialog/aeps_rd_service_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/page/exception_page.dart';

import '../../../service/native_call.dart';
import '../../../util/mixin/transaction_helper_mixin.dart';

class AepsAirKycController extends GetxController with TransactionHelperMixin {
  var formOneKey = GlobalKey<FormState>();
  var otpController = TextEditingController();
  var aadhaarController = TextEditingController();
  var actionTypeObs = AepsAirKycActionType.verifyOtp.obs;

  late EKycResponse kycResponse;

  AepsAirtelRepo repo = Get.find<AepsAirtelRepoImpl>();

  String? token = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      requestOtp();
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    aadhaarController.dispose();
    super.dispose();
  }

  String getButtonText() {
    switch (actionTypeObs.value) {
      case AepsAirKycActionType.verifyOtp:
        return "Verify Otp";
      case AepsAirKycActionType.verifyBiometric:
        return "Capture Fingerprint";
    }
  }

  void onSubmit() async {
    if (!formOneKey.currentState!.validate()) return;

    switch (actionTypeObs.value) {
      case AepsAirKycActionType.verifyOtp:
        _verifyOtp();
        break;
      case AepsAirKycActionType.verifyBiometric:
        _showRdServiceDialog();
        break;
    }
  }

  requestOtp() async {
    try {
      StatusDialog.progress();
      final result = await repo.requestGenerateTokenOtp();
      Get.back();
      if (result.code == 1) {
        token = result.token;
        StatusDialog.success(title: result.message);
      } else {
        StatusDialog.failure(title: result.message).then((value) => Get.back());
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));

    }
  }

  _verifyOtp() async {
    if (!formOneKey.currentState!.validate()) return;
    if (token == null) {
      StatusDialog.alert(title: "Token not found!");
      return;
    }

    try {
      StatusDialog.progress(title: "Verifying Otp");
      var response = await repo.verifyGenerateTokenOpt({
        "otp": otpController.text,
        "token": token ?? "",
      });
      Get.back();
      if (response.code == 1) {
        token = response.token;
        StatusDialog.success(title: response.message).then((value) {
          actionTypeObs.value = AepsAirKycActionType.verifyBiometric;
        });
      } else {
        StatusDialog.failure(title: response.message);
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
          var result = await NativeCall.launchAirtelAepsService({
            "packageUrl": rdServicePackageUrl,
            "isTransaction": false
          });
          if(result["pidData"].toString().trim() == ""){
            StatusDialog.alert(title: "Fingerprint capture failed! Please try again!");
          }
          else{
            _verifyBiometricData(result);
          }
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

  _verifyBiometricData(Map<dynamic,dynamic> biometricData) async {
    if (!formOneKey.currentState!.validate()) return;
    if (token == null) {
      StatusDialog.failure(title: "Token not found!");
      return;
    }

    StatusDialog.progress(title: "Authenticating");

    try {

      final String hMac = biometricData["hMac"];
      final String pidData = biometricData["pidData"];
      final String deviceCode = biometricData["deviceCode"];
      final String modelId = biometricData["modelId"];
      final String providerCode = biometricData["providerCode"];
      final String certificateCode = biometricData["certificateCode"];
      final String serviceId = biometricData["serviceId"];
      final String deviceVersion = biometricData["deviceVersion"];
      final String sKey = biometricData["sKey"];
      final String sKeyCI = biometricData["sKeyCI"];
      final String deviceSerialNumber = biometricData["deviceSerialNumber"];


      var response = await repo.verifyBiometricData({
        "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
        "ci": sKeyCI,
        "hmac": hMac,
        "Piddata": pidData,
        "devicecode": deviceCode,
        "modelid": modelId,
        "providercode":providerCode,
        "certicode": certificateCode,
        "serviceid":serviceId,
        "devicever": deviceVersion,
        "Skey": sKey,
        "srno": deviceSerialNumber,
        "token": token ?? ""
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.offNamed(AppRoute.aepsAirtelPage));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}

enum AepsAirKycActionType { verifyOtp, verifyBiometric }
