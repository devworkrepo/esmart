import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/util/picker_helper.dart';

import '../../exception_page.dart';


class SettlementBankAddController extends GetxController
    with TransactionHelperMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AppPreference appPreference = Get.find();
  AepsRepo repo = Get.find<AepsRepoImpl>();

  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController uploadSlipController = TextEditingController();
  File? selectedImageFile;

  bool goBack = Get.arguments;

  @override
  void dispose() {
    accountHolderController.dispose();
    ifscController.dispose();
    accountController.dispose();
    bankNameController.dispose();
    uploadSlipController.dispose();
    super.dispose();
  }

  showImagePickerBottomSheetDialog() async {
    ImagePickerHelper.pickImageWithCrop((File? image) {
      selectedImageFile = image;
      if (image == null) {
        uploadSlipController.text = "";
      } else {
        var fileName = selectedImageFile!.path.split("/").last;
        var fileExtension = path.extension(fileName);
        uploadSlipController.text =
            "smart_bazaar_receipt_${DateTime.now().millisecondsSinceEpoch}" +
                fileExtension;
      }
    }, () {
      selectedImageFile = null;
      uploadSlipController.text = "";
    });
  }

  onAddButtonClick() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return;
    _addNewBank();
  }

  _addNewBank() async {
    StatusDialog.progress();
    try {
      var formDataParam = await _addBankParam();
      CommonResponse response = await repo.addSettlementBank(formDataParam);

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value){
              if(goBack){
                Get.back(result: true);
              }else{
                Get.offNamed(AppRoute.aepsSettlemenBankListtPage);
              }
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  Future<dio.FormData> _addBankParam() async {
    dio.MultipartFile? fileData;
    if (selectedImageFile != null) {
      fileData = await dio.MultipartFile.fromFile(selectedImageFile!.path,
          filename:
              selectedImageFile!.path.split("/").last.replaceAll("..", "."));
    }

    var param = {
      "sessionkey": appPreference.sessionKey,
      "dvckey": await AppUtil.getDeviceID(),
      "acc_name" : accountHolderController.text,
      "acc_no" : accountController.text,
      "ifsc" : ifscController.text,
      "bank_name" : bankNameController.text,
      "images ": fileData,
    };

    return dio.FormData.fromMap(param);
  }
}
