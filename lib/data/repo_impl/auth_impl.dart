import 'package:esmartbazaar/data/repo/auth_repo.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/user/login.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/api/exception.dart';

class AuthRepoImpl extends AuthRepo {
  final NetworkClient client = Get.find();


  @override
  Future<LoginResponse> agentLogin(Map<String, String> data) async {
    var response = await client.post("AgentLogin", data: data,isAdditionalData: false);
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> subAgentLogin(Map<String, String> data) async {
    var response = await client.post("SubAgentLogin", data: data,isAdditionalData: false);
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> loginOtp(Map<String, String> data) async {
    var response = await client.post("LoginOTPVerify", data: data,isAdditionalData: false);
    return LoginResponse.fromJson(response.data);
  }


  @override
  Future<CommonResponse> resendLoginOtp(Map<String, String> data) async {
    var response = await client.post("LoginOTP", data: data,isAdditionalData: false);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordRequestOtp(Map<String, String> data) async {
    var response = await client.post("forget-password", data: data,isAdditionalData: false);
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> forgotPasswordVerifyOtp(Map<String, String> data) async {
    var response = await client.post("set-forget-password", data: data,isAdditionalData: false);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordResendOtp(Map<String, String> data) async {
    var response = await client.post("resend-forgot-password-otp", data: data,isAdditionalData: false);
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkDevice(data) async{
    var response = await client.post("CheckDvc",data: data,isAdditionalData: false);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> registerNewDevice(data) async
  {
    var response = await client.post("RegisterDvc",data: data,isAdditionalData: false);
    return CommonResponse.fromJson(response.data);
  }

}
