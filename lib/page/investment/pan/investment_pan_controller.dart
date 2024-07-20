import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo/singup_repo.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/data/repo_impl/singup_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/singup/verify_pan_response.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/picker_helper.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio;
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class InvestmentPanController extends GetxController {
  var panName = "".obs;
  var panInputController = TextEditingController();
  var docPanController = TextEditingController();
  File? panFile;

  AppPreference appPreference = Get.find();
  SignUpRepo signUpRepo = Get.find<SingUpRepoImpl>();
  SecurityDepositRepo securityDepositRepo = Get.find<SecurityDepositImpl>();

  void verifyPanNumber() async {
    var panNumber = panInputController.text.toString();
    if (panNumber.length != 10) {
      StatusDialog.alert(title: "Enter 10 characters valid PAN Number!");
      return;
    }

    StatusDialog.progress(title: "Verifying Pan...");
    try {
      SignUpVerifyPanResponse response = await signUpRepo.verifyPan({
        "panno": panNumber,
      });

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: "Pan verified successfully!").then((value) {
          panName.value = response.pan_name ?? "";
          FocusScope.of(Get.context!).unfocus();
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
          "Something went wrong! please try again after sometime! thank you.");
    }
  }

  showImagePickerBottomSheetDialog() async {
    ImagePickerHelper.pickImageWithCrop((File? image) {
      panFile = image;
      if (image == null) {
        docPanController.text = "";
      } else {
        var fileName = panFile!.path.split("/").last;
        var fileExtension = path.extension(fileName);
        docPanController.text =
            "pan_${DateTime.now().millisecondsSinceEpoch}" + fileExtension;
      }
    }, () {

        panFile = null;
        docPanController.text = "Uploading please wait...";

    });
  }


  _finalSubmit() async {
    StatusDialog.progress(title: "Submitting...");

    try {
      var formDataParam = await _finalRequestParam();
      CommonResponse response = await securityDepositRepo.uploadPanDetail(formDataParam);
      Get.back();
      if (response.code == 1) {
        Get.back();
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
          "Something went wrong! please try again after sometime! thank you.");
    }
  }

  Future<dio.FormData> _finalRequestParam() async {

    dio.MultipartFile? panFileFilePart;

    panFileFilePart = await dio.MultipartFile.fromFile(panFile!.path,
        filename: panFile!.path.split("/").last.replaceAll("..", "."));

    var param = {
      "filename": panFileFilePart,
      "pan_name": panName.value,
      "pan_no": panInputController.text.toString(),
      "sessionkey": appPreference.sessionKey,
      "dvckey": await AppUtil.getDeviceID(),
    };
    return dio.FormData.fromMap(param);
  }

  void onSubmit()  {
    if(panInputController.text.length != 10){
      StatusDialog.alert(title: "Enter pan number");
      return;
    }
    if(panFile == null){
      StatusDialog.alert(title: "Upload pan image");
      return;
    }
    _finalSubmit();
  }
}
