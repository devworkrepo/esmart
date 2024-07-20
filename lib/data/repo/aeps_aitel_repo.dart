import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/aeps_token.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:dio/dio.dart' as dio;


abstract class AepsAirtelRepo {
  //aeps
  Future<AepsBankResponse> fetchAepsBankList();

  Future<AepsTransactionResponse> aepsTransaction(data);

  //on boarding
  Future<CommonResponse> aepsOnBoarding(data);
  Future<CommonResponse> aepsImageOnBoarding(dio.FormData data);

  Future<AepsTokenCheckResponse> checkToken();
  Future<AepsTokenCheckResponse> requestGenerateTokenOtp();
  Future<AepsTokenCheckResponse> verifyGenerateTokenOpt(data);
  Future<CommonResponse> verifyBiometricData(data);
}
