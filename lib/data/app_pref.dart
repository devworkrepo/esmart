import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/util/security/encription.dart';

import '../model/alert.dart';

class AppPreference {
  final SharedPreferences _sharedPreferences;

  AppPreference(this._sharedPreferences);

  final _token = "token";
  final _user = "user";
  final _balance = "balance";
  final _isLoginCheck = "is_login_check";
  final _password = "password";
  final _mobileNumber = "mobile_number";
  final _isTransactionApi = "is_transaction_api";
  final _isLoginBondAccepted = "is_login_bond_accepted";
  final _rdService = "rd_service";
  final _biometricServiceEnable = "biometric_service_enable";
  final _appUpdateDelayTime = "app_update_delay_time";
  final _appUpdateDelayHour = "app_update_delay_hour";

  setPassword(String value) => _saveStringData(_password, value);

  String get password => _retrieveStringData(_password);

  setMobileNumber(String value) => _saveStringData(_mobileNumber, value);

  String get mobileNumber => _retrieveStringData(_mobileNumber);

  setSessionKey(String value) async {
    return await _saveStringData(_token, value);
  }

  String get sessionKey => _retrieveStringData(_token);

  setRdService(String value) async {
    return await _saveStringData(_rdService, value);
  }

  String get rdService => _retrieveStringData(_rdService);

  setUser(UserDetail value) async {
    String user = jsonEncode(value);
    return await _saveStringData(_user, user);
  }

  UserDetail get user {
    var json = jsonDecode(_retrieveStringData(_user));
    var user = UserDetail.fromJson(json);
    return user;
  }

  setIsTransactionApi(bool value) async {
    _saveBoolData(_isTransactionApi, value);
  }

  bool get isTransactionApi {
    return _retrieveBoolData(_isTransactionApi);
  }

  setIsLoginBondAccepted(bool value) async {
    _saveBoolData(_isLoginBondAccepted, value);
  }

  bool get isLoginBondAccepted {
    return _retrieveBoolData(_isLoginBondAccepted);
  }

  setIsLoginCheck(bool value) => _saveBoolData(_isLoginCheck, value);

  bool get isLoginCheck => _retrieveBoolData(_isLoginCheck);

  setAppUpdateTimeWaiting(int value) =>
      _saveIntData(_appUpdateDelayTime, value);

  setOptionalUpdateDelayHour(int value) =>
      _saveIntData(_appUpdateDelayHour, value);

  int get appUpdateTimeWaiting => _retrieveIntData(_appUpdateDelayTime);

  int get optionalUpdateDelayHour => _retrieveIntData(_appUpdateDelayHour);

  setBiometricAuthentication(bool value) =>
      _saveBoolData(_biometricServiceEnable, value);

  bool get isBiometricAuthentication =>
      _retrieveBoolData(_biometricServiceEnable, defaultValue: false);

  _saveStringData(String key, String value) {
    var eData = Encryption.aesEncrypt((value.isEmpty) ? "na" : value);
    return _sharedPreferences.setString(key, eData);
  }

  _retrieveStringData(String key) {
    var dData = _sharedPreferences.getString(key) ?? "";
    if (dData.isEmpty) return "";
    if (dData == "na") return "";
    return Encryption.aepDecrypt(dData);
  }

  _saveBoolData(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  _retrieveBoolData(String key, {bool defaultValue = false}) =>
      _sharedPreferences.getBool(key) ?? defaultValue;

  _saveIntData(String key, int value) => _sharedPreferences.setInt(key, value);

  _retrieveIntData(String key, {int defaultValue = 0}) =>
      _sharedPreferences.getInt(key) ?? defaultValue;

  Future<bool> logout() async {
    await setIsTransactionApi(false);
    await setUser(UserDetail.fromJson({
      "code": 1,
      "message": "na",
      "status": "na",
      "agentId": "na",
      "fullName": "na",
      "outletName": "na",
      "picName": "na",
      "agentCode": "na",
      "userType": "na",
      "availableBalance": "0",
      "openBalance": "0",
      "creditBalance": "0",
      "isPayoutBond": false,
      "isWalletPay": false,
      "isRecharge": false,
      "isDth": false,
      "isInsurance": false,
      "isInstantPay": false,
      "isBill": false,
      "isCreditCard": false,
      "isPaytmWallet": false,
      "isLic": false,
      "isOtt": false,
      "isBillPart": false,
      "isAeps": false,
      "isMatm": false,
    }));

    if (!isLoginCheck) {
      await setPassword("na");
      await setMobileNumber("na");
    }
    await setSessionKey("na");
    return true;
  }
}
