import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:dio/dio.dart' as dio;
import '../../model/aeps/aeps_state.dart';

abstract class AepsFingRepo {

  //aeps
  Future<AepsBankResponse> fetchAepsBankList();
  Future<AepsTransactionResponse> aepsTransaction(data);
  Future<CommonResponse> proceedDaily2FAuth(data);
  Future<CommonResponse> checkDaily2FAuth();

  //onbaording
  Future<AepsStateListResponse> getAepsState();
  Future<CommonResponse> onBoardAeps(data);
  Future<CommonResponse> aepsImageOnBoarding(dio.FormData data);

  //kyc
  Future<EKycResponse> eKycSendOtp(data);
  Future<EKycResponse> eKycResendOtp(data);
  Future<EKycResponse> eKycVerifyOtp(data);
  Future<CommonResponse> eKycAuthenticate(data);


}
