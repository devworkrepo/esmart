import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/singup/captcha_response.dart';
import 'package:esmartbazaar/model/singup/kyc_detail_response.dart';
import 'package:esmartbazaar/model/singup/kyc_otp_response.dart';
import 'package:esmartbazaar/model/singup/signup_state.dart';
import 'package:esmartbazaar/model/singup/verify_pan_response.dart';
import 'package:esmartbazaar/service/network_sign_up_client.dart';
import 'package:esmartbazaar/util/api/test_response.dart';

import '../../model/common.dart';

import '../../model/singup/final_signup_response.dart';
import '../repo/singup_repo.dart';
import 'package:dio/dio.dart' as dio;


class SingUpRepoImpl extends SignUpRepo {
  NetworkSignUpClient client = Get.find();

  @override
  Future<CommonResponse> sendMobileOtp(Map<String, String> data)  async{
   var response = await client.post("/SendOTP",data: data);
   return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> verifyMobileOtp(Map<String, String> data) async{
    var response = await client.post("/SendOTPVerify",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<SignUpCaptchaResponse> getCaptcha(Map<String, String> data) async{
    var response = await client.post("/GetCaptcha",data: data);
    return SignUpCaptchaResponse.fromJson(response.data);
  }
  @override
  Future<SignUpCaptchaResponse> getReCaptcha(Map<String, String> data) async {
    var response = await client.post("/GetReCaptcha",data: data);
    return SignUpCaptchaResponse.fromJson(response.data);
  }

  @override
  Future<SignUpEKycResponse> sendEKycOtp(Map<String, String> data) async{
    var response = await client.post("/SendEKycOTP",data: data);
    return SignUpEKycResponse.fromJson(response.data);
  }
  
  @override
  Future<SignUpEKycResponse> resendEKycOtp(Map<String, String> data) async{
    var response = await client.post("/ReSendEKycOTP",data: data);
    return SignUpEKycResponse.fromJson(response.data);
  }



  @override
  Future<SignUpEKycResponse> verifyEKycOtp(Map<String, String> data) async{
    var response = await client.post("/VerifyEKycOTP",data: data);
    return SignUpEKycResponse.fromJson(response.data);
  }


  @override
  Future<SignUpKycDetailResponse> getKycDetail(Map<String, String> data) async{
    var response = await client.post("/GetKycDetails",data: data);
    return SignUpKycDetailResponse.fromJson(response.data);
  }



  @override
  Future<SignUpVerifyPanResponse> verifyPan(Map<String, String> data) async{
    var response = await client.post("/VerifyPAN",data: data);
    return SignUpVerifyPanResponse.fromJson(response.data);
  }

  @override
  Future<SignupStateListResponse> getStateList() async{
    var response = await client.post("/GetStatesList");
    return SignupStateListResponse.fromJson(response.data);
  }

  @override
  Future<SignUpResponse> signUpUser(dio.FormData data) async{

    var response = await client.post("/AddSignUp",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return SignUpResponse.fromJson(response.data);

  }


  @override
  Future<CommonResponse> updateAadhaarImage(dio.FormData data) async {
    var response = await client.post("/UpdateAadharPic",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> updatePanImage(dio.FormData data) async {
    var response = await client.post("/UpdatePanPic",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }




}
