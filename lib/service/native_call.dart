import 'dart:async';

import 'package:flutter/services.dart';
import 'package:esmartbazaar/util/app_util.dart';

class NativeCall {
  static const _methodChannelName = "app.esmartbazaar.com";
  static const _methodChannel = MethodChannel(_methodChannelName);
  static const _aepsServiceMethodName = "launch_aeps_service";
  static const _faceCaptureMethodName = "launch_face_capture";
  static const _dmtTwoAuthPidData = "dmt_two_auth_pid_data";
  static const _matmServiceMethodName = "launch_matm_service";
  static const _rdServiceSerialNumber = "rd_service_serial_number";
  static const _rootCheckerService = "root_checker_service";
  static const _bluetoothService = "bluetooth_service";
  static const _bluetoothCheckEnable = "bluetooth_check_enable";
  static const _bluetoothCheckPaired = "bluetooth_check_paired";
  static const _credoPayService = "credo_pay_service";
  static const _upiPayment = "upi_payment";

  static Future<String> launchTramoAepsService(Map<String, dynamic> data) async {
    data.addAll({"provider": "tramo"});
    final String result =
        await _methodChannel.invokeMethod(_aepsServiceMethodName, data);
    return result;
  }

  static Future<String> launchForDmtTwoAuthPidXmlData(Map<String, dynamic> data) async {
    final String result =
    await _methodChannel.invokeMethod(_dmtTwoAuthPidData, data);
    return result;
  }

  static Future<Map<dynamic, dynamic>> launchAirtelAepsService(
      Map<String, dynamic> data) async {
    data.addAll({"provider" : "airtel"});
    final Map<dynamic, dynamic> result =
        await _methodChannel.invokeMethod(_aepsServiceMethodName, data);

    print(result);
    return result;
  }

  static Future<String> launchResultForAEPSData(
      Map<String, dynamic> data) async {
    data.addAll({"provider" : "common"});
    String result = await _methodChannel.invokeMethod(_aepsServiceMethodName, data);
    return result;
  }

  static Future<String> launchResultForFaceAuth(Map<String, dynamic> data) async {
    String result = await _methodChannel.invokeMethod(_faceCaptureMethodName, data);
    return result;
  }

  static Future<Map<dynamic, dynamic>> launchMatmService(
      Map<String, dynamic> data) async {
    return await _methodChannel.invokeMethod(_matmServiceMethodName, data);
  }

  static Future<String> getRdSerialNumber(String data) async {
    var resultData = await _methodChannel
        .invokeMethod(_rdServiceSerialNumber, {"pidData": data});
    return resultData;
  }

  static Future<Map<dynamic, dynamic>> credoPayService(
      Map<String, dynamic> data) async {
    var resultData = await _methodChannel.invokeMethod(_credoPayService, data);

    AppUtil.logger("credoPay Native call response : $resultData");
    return resultData;
  }

  static Future<bool> isDeviceRooted() async {
    var resultData = await _methodChannel.invokeMethod(_rootCheckerService);
    return resultData ?? false;
  }

  static Future<bool> bluetoothCheckEnable() async {
    bool? resultData = await _methodChannel.invokeMethod(_bluetoothCheckEnable);
    return resultData ?? true;
  }

  static Future<bool> bluetoothCheckPaired() async {
    bool? resultData = await _methodChannel.invokeMethod(_bluetoothCheckPaired);
    return resultData ?? true;
  }

  static Future<Map<dynamic, dynamic>> upiPayment(
      Map<String, dynamic> data) async {
    var resultData = await _methodChannel.invokeMethod(_upiPayment, data);
    AppUtil.logger("upiPayment Native call response : $resultData");
    return resultData;
  }
}
