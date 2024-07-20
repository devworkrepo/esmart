import 'dart:collection';

import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/singup/captcha_response.dart';
import 'package:esmartbazaar/model/singup/kyc_detail_response.dart';
import 'package:esmartbazaar/model/singup/kyc_otp_response.dart';
import 'package:esmartbazaar/model/singup/signup_state.dart';
import 'package:esmartbazaar/model/singup/singup_user_response.dart';
import 'package:esmartbazaar/model/singup/verify_pan_response.dart';
import 'package:esmartbazaar/model/user/login.dart';
import 'package:dio/dio.dart' as dio;

import '../../model/singup/final_signup_response.dart';


abstract class SignUpRepo {

  Future<CommonResponse> sendMobileOtp(Map<String,String> data);
  Future<CommonResponse> verifyMobileOtp(Map<String,String> data);
  Future<SignUpCaptchaResponse> getCaptcha(Map<String,String> data);
  Future<SignUpCaptchaResponse> getReCaptcha(Map<String,String> data);
  Future<SignUpEKycResponse> sendEKycOtp(Map<String,String> data);
  Future<SignUpEKycResponse> resendEKycOtp(Map<String,String> data);
  Future<SignUpEKycResponse> verifyEKycOtp(Map<String,String> data);
  Future<SignUpKycDetailResponse> getKycDetail(Map<String,String> data);
  Future<SignUpVerifyPanResponse> verifyPan(Map<String,String> data);
  Future<SignupStateListResponse> getStateList();
  Future<SignUpResponse> signUpUser(dio.FormData data);
  Future<CommonResponse> updateAadhaarImage(dio.FormData data);
  Future<CommonResponse> updatePanImage(dio.FormData data);

}
