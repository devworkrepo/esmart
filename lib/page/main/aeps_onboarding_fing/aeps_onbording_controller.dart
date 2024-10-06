import 'dart:io';

import 'package:esmartbazaar/data/repo_impl/aeps_fing_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/model/aeps/aeps_state.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

import '../../../data/repo/aeps_aitel_repo.dart';
import '../../../data/repo/aeps_fing_repo.dart';
import '../../../data/repo_impl/aeps_aitel_impl.dart';
import '../../../service/location.dart';
import '../../../util/app_util.dart';
import '../../../util/picker_helper.dart';
import '../../exception_page.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio;



class AepsOnboardingFingController extends GetxController
    with LocationHelperMixin, TransactionHelperMixin {
  AepsFingRepo repo = Get.find<AepsFingRepoImpl>();


  AppPreference appPreference = Get.find();

  var aadhaarController = TextEditingController();
  var panController = TextEditingController();
  var ifscController = TextEditingController();
  var accountController = TextEditingController();
  var nameController = TextEditingController();
  var bankNameController = TextEditingController();
  var branchNameController = TextEditingController();
  var pinCodeController = TextEditingController();
  var cityNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var stateListResponseObs = Resource.onInit(data: AepsStateListResponse()).obs;
  late List<AepsState> aepsStateList;



  TextEditingController uploadPanController = TextEditingController();
  TextEditingController uploadIdController = TextEditingController();
  File? selectedPanImageFile;
  File? selectedIdImageFile;

  AepsState? selectedState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
      _fetchAepsState();

    });
  }

  _fetchAepsState() async {
    try {
      obsResponseHandler<AepsStateListResponse>(
          obs: stateListResponseObs,
          apiCall: repo.getAepsState(),
          onResponse: (data) {
            aepsStateList = data.stateList!;
          });
    } catch (e) {
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onProceed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      position = await LocationService.determinePosition();

      AppUtil.logger("Position : " + position.toString());
    } catch (e) {
      return;
    }
    try {
      StatusDialog.progress(title: "Progressing");

      final params = {
        "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
        "pan_no": panController.text.toString(),
        "account_name": nameController.text.toString(),
        "account_no": accountController.text.toString(),
        "ifsc_code": ifscController.text,
        "bank_name":bankNameController.text.toString() ,
        "branch_name": branchNameController.text.toString(),
        "cityname": cityNameController.text.toString(),
        "pincode": pinCodeController.text.toString(),
        "stateid": selectedState!.id.toString(),
        "statename": selectedState!.name.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      };

     final response =  await repo.onBoardAeps(params);

      if (response.code == 1) {
       try{
         await repo.aepsImageOnBoarding(await _aepsImageMultipartParam(response.refid!,FingOnboardingDocType.pan));
         await repo.aepsImageOnBoarding(await _aepsImageMultipartParam(response.refid!,FingOnboardingDocType.id));
       }catch(e){
         e.printError();
       }
       Get.back();
       StatusDialog.success(title: response.message);
      }
      else if(response.code == 3){
        Get.back();
        StatusDialog.success(title: response.message).then((value) => Get.offAllNamed(AppRoute.mainPage));
      }else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  Future<dio.FormData> _aepsImageMultipartParam(String refId, FingOnboardingDocType type) async {
    dio.MultipartFile? fileData;

    var picType = "pan";
    if(type == FingOnboardingDocType.pan){
      if (selectedPanImageFile != null) {
        fileData = await dio.MultipartFile.fromFile(selectedPanImageFile!.path,
            filename:
            selectedPanImageFile!.path.split("/").last.replaceAll("..", "."));
      }
      picType = "pan";
    }
    else{
      if (selectedIdImageFile != null) {
        fileData = await dio.MultipartFile.fromFile(selectedIdImageFile!.path,
            filename:
            selectedIdImageFile!.path.split("/").last.replaceAll("..", "."));
      }
      picType = "id";
    }


    var param = {
      "sessionkey": appPreference.sessionKey,
      "dvckey": await AppUtil.getDeviceID(),
      "images ": fileData,
      "pictype" : picType,
      "refid" : refId,
    };
    return dio.FormData.fromMap(param);
  }

  showImagePickerBottomSheetDialog(FingOnboardingDocType type) async {

   if(type == FingOnboardingDocType.pan){
     ImagePickerHelper.pickImageWithCrop((File? image) {
       selectedPanImageFile = image;
       if (image == null) {
         uploadPanController.text = "";
       } else {
         var fileName =  selectedPanImageFile!.path.split("/").last;
         var fileExtension = path.extension(fileName);
         uploadPanController.text ="aadhaar_${DateTime.now().millisecondsSinceEpoch}"+fileExtension;
       }
     },(){
       selectedPanImageFile = null;
       uploadPanController.text = "Uploading please wait...";
     });
   }
   else{
     ImagePickerHelper.pickImageWithCrop((File? image) {
       selectedIdImageFile = image;
       if (image == null) {
         uploadIdController.text = "";
       } else {
         var fileName =  selectedIdImageFile!.path.split("/").last;
         var fileExtension = path.extension(fileName);
         uploadIdController.text ="cancel_cheque_${DateTime.now().millisecondsSinceEpoch}"+fileExtension;
       }
     },(){
       selectedIdImageFile = null;
       uploadIdController.text = "Uploading please wait...";
     });
   }
  }


  @override
  void dispose() {
    aadhaarController.dispose();
    super.dispose();
  }


}

enum FingOnboardingDocType{
  pan,id
}
