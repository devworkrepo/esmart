import 'dart:collection';

import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/user/login.dart';

abstract class AuthRepo {

  Future<LoginResponse> agentLogin(Map<String,String> data);
  Future<LoginResponse> subAgentLogin(Map<String,String> data);
  Future<CommonResponse> checkDevice(data);
  Future<CommonResponse> registerNewDevice(data);
  Future<LoginResponse> loginOtp(Map<String,String> data);
  Future<CommonResponse> resendLoginOtp(Map<String,String> data);
  Future<ForgotPasswordResponse> forgotPasswordResendOtp(Map<String,String> data);
  Future<ForgotPasswordResponse> forgotPasswordRequestOtp(Map<String,String> data);
  Future<CommonResponse> forgotPasswordVerifyOtp(Map<String,String> data);

}
