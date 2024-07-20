import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/qr_code/qrcode_response.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/app_pref.dart';
import '../exception_page.dart';

class MyQRCodeController extends GetxController {
  var appPreference = Get.find<AppPreference>();

  var reportResponseObs = Resource.onInit(data: QRCodeListResponse()).obs;
  final HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchQRCodes();
    });
  }

  _fetchQRCodes() async {
    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchQRCodes();
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }
}
