import 'dart:io';

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
import '../../../data/repo_impl/aeps_aitel_impl.dart';
import '../../../service/location.dart';
import '../../../util/app_util.dart';
import '../../../util/picker_helper.dart';
import '../../exception_page.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio;



class AepsOnboardingController extends GetxController
    with LocationHelperMixin, TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AepsAirtelRepo aepsAitelRepo = Get.find<AepsAirtelRepoImpl>();

  AppPreference appPreference = Get.find();

  bool isApesTramo = Get.arguments ?? true;

  var aadhaarController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var stateListResponseObs = Resource.onInit(data: AepsStateListResponse()).obs;
  late List<AepsState> aepsStateList;



  TextEditingController uploadSlipController = TextEditingController();
  File? selectedImageFile;

  AepsState? selectedState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
      if (isApesTramo) _fetchAepsState();

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
      var response = (isApesTramo)
          ? await repo.onBoardAeps({
              "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
              "stateid": selectedState!.id.toString(),
              "statename": selectedState!.name.toString(),
              "latitude": position!.latitude.toString(),
              "longitude": position!.longitude.toString(),
            })
          : await aepsAitelRepo.aepsImageOnBoarding(await _aepsImageMultipartParam());
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message);
      }
      else if(response.code == 3){
        StatusDialog.success(title: response.message).then((value) => Get.offAllNamed(AppRoute.mainPage));
      }else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  Future<dio.FormData> _aepsImageMultipartParam() async {
    dio.MultipartFile? fileData;

    if (selectedImageFile != null) {
      fileData = await dio.MultipartFile.fromFile(selectedImageFile!.path,
          filename:
          selectedImageFile!.path.split("/").last.replaceAll("..", "."));
    }
    var param = {
      "sessionkey": appPreference.sessionKey,
      "dvckey": await AppUtil.getDeviceID(),
      "images ": fileData,
      "latitude": position!.latitude.toString(),
      "longitude": position!.longitude.toString(),
    };
    return dio.FormData.fromMap(param);
  }

  showImagePickerBottomSheetDialog() async {

    ImagePickerHelper.pickImageWithCrop((File? image) {
      selectedImageFile = image;
      if (image == null) {
        uploadSlipController.text = "";
      } else {
        var fileName =  selectedImageFile!.path.split("/").last;
        var fileExtension = path.extension(fileName);
        uploadSlipController.text ="aadhaar_${DateTime.now().millisecondsSinceEpoch}"+fileExtension;
      }
    },(){
      selectedImageFile = null;
      uploadSlipController.text = "Uploading please wait...";
    });
  }


  @override
  void dispose() {
    aadhaarController.dispose();
    super.dispose();
  }
}
