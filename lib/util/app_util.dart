import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'dart:developer';

import '../service/local_auth.dart';
import 'api/exception.dart';
import 'app_constant.dart';

class AppUtil {
  static logger(value) {
    if (!kReleaseMode) {
      print('\x1B[32m$value\x1B[0m');
    }
  }

  static Future<String> getDeviceID() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }

  static Future<String> serialNumber() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.hardware;
    }
  }

  static Future<String> modelName() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.brand + " " + androidDeviceInfo.model;
    }
  }

  static Future<Map<String, dynamic>> parseJsonFromAssets(
      String fileName) async {
    await Future.delayed(const Duration(seconds: 2));
    return rootBundle
        .loadString("assets/json/" + fileName + ".json")
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  static void captureAndShare(
      {required ScreenshotController screenshotController,
        required String amount,
        required String type}) async {
    var image = await screenshotController.capture();

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File("${directory.path}/esmartbazaar.png");

    final text = "$type for Rs. $amount";

    imageFile.writeAsBytesSync(image);
    await Share.shareFiles([imageFile.path], text: text);
  }


  static void throwUatExceptionOnDeployment(String mobileNumber) {

    var whiteListNumbers = ["7982607742", "9785172173", "9211044444"];

    if (kReleaseMode && AppConstant.baseUrl == AppConstant.uatBaseUrl) {
      var isExist = false;
      for (var element in whiteListNumbers) {
        if (mobileNumber == element) {
          isExist = true;
          break;
        }
      }

      if (!isExist) {
         throw UatUpdateException();
      }
    }
  }

  static String changeDateToMMDDYYYY(String value){
    if(value.isEmpty) return value;
    var mList = value.split("/");
    return mList[1] +"/" +mList[0] +"/"+mList[2];
  }

  static Future<bool> isDeviceHasLock() async {
    return await LocalAuthService.isAvailable();
  }


}
