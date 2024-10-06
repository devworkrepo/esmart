import 'package:dio/dio.dart';
import 'package:esmartbazaar/data/repo/aeps_fing_repo.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:dio/dio.dart' as dio;
import '../../model/aeps/aeps_state.dart';

class AepsFingRepoImpl extends AepsFingRepo {
  NetworkClient client = Get.find();

  @override
  Future<AepsBankResponse> fetchAepsBankList() async {
    var response = await client.post("/GetAEPSBanksFing");
    return AepsBankResponse.fromJson(response.data);
  }

  @override
  Future<AepsTransactionResponse> aepsTransaction(data) async {
    var response = await client.post("/AEPSTransactionFing", data: data);
    return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<AepsStateListResponse> getAepsState() async {
    var response = await client.post(
      "/GetStatesAEPS",
    );
    return AepsStateListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> onBoardAeps(data) async {
    var response = await client.post("/OnBoardAEPSFing", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> aepsImageOnBoarding(dio.FormData data) async {
    var response = await client.post("/UpdateOnBoardPicsFing",
        data: data,
        options: Options(
            contentType: "application/json",
            headers: {"Accept": "application/json"}));
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> eKycAuthenticate(data) async {
    var response = await client.post("/KycAuth", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<EKycResponse> eKycResendOtp(data) async {
    var response = await client.post("/ResendKycOTP", data: data);
    return EKycResponse.fromJson(response.data);
  }

  @override
  Future<EKycResponse> eKycSendOtp(data) async {
    var response = await client.post("/SendKycOTP", data: data);
    return EKycResponse.fromJson(response.data);
  }

  @override
  Future<EKycResponse> eKycVerifyOtp(data) async {
    var response = await client.post("/VerifyKycOTP", data: data);
    return EKycResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> proceedDaily2FAuth(data) async {
    var response = await client.post("/DailyAuthFing", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkDaily2FAuth() async {
    var response = await client.post("/CheckDailyAuthFing");
    return CommonResponse.fromJson(response.data);
  }
}
