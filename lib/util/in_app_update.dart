import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart' as inAppUpdate;
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/app_update.dart';

import '../widget/common.dart';
import 'app_util.dart';

class AppUpdateUtil {

  AppUpdateUtil._();

  static Future<void> checkUpdate() async {

    if(kDebugMode) return;

    InAppUpdate.checkForUpdate().then((info)  async{
      var isUpdateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;

      AppUtil.logger("InAppUpdate : package name : ${info.packageName}");

      if (isUpdateAvailable) {
        _fetchUpdateDetail();
      } else {
        AppUtil.logger("InAppUpdate : app update not available");
      }
    }).catchError((e) {
      AppUtil.logger("InAppUpdateError : _checkForUpdate" + e.toString());

      if (e is PlatformException) {
      } else {
        showFailureSnackbar(title: "Update Failed", message: e.toString());
      }
    });
  }


  static _fetchUpdateDetail() async{
    try{
      NetworkAppUpdateInfo info = await Get.find<HomeRepoImpl>().updateInfo();
      _performImmediateUpdate(info.isUpdate ?? true,info.isForce ?? true);
    }catch(e){
      _performImmediateUpdate(true,true);
    }
  }

  static _performImmediateUpdate(bool isUpdate, bool isForceUpdate) {
    if(!isUpdate) return;
    InAppUpdate.performImmediateUpdate().catchError((e) {
      AppUtil.logger(
          "InAppUpdateError _performImmediateUpdate: " + e.toString());
      if(isForceUpdate){
        checkUpdate();
      }
    }).then((value) {
     var success =  inAppUpdate.AppUpdateResult.success;
      if( value != success){
        if(isForceUpdate){ checkUpdate();}
      }
    });
  }

  static _performFlexibleUpdate() {
    InAppUpdate.startFlexibleUpdate().then((value) =>
        InAppUpdate.completeFlexibleUpdate().then((value) =>
            showSuccessSnackbar(
                title: "Update Completed", message: "App is update to date")));
  }


}
