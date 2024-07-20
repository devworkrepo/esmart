import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/model/aeps/settlement/aeps_calc.dart';
import 'package:esmartbazaar/model/aeps/settlement/balance.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/model/common.dart';

import '../../model/aeps/aeps_state.dart';
import '../../model/matm/matm_request_response.dart';
import '../../model/report/requery.dart';

abstract class AepsFingRepo {

  //aeps
  Future<AepsBankResponse> fetchAepsBankList();
  Future<AepsTransactionResponse> aepsTransaction(data);
  Future<CommonResponse> proceedDaily2FAuth(data);
  Future<CommonResponse> checkDaily2FAuth();

  //onbaording
  Future<AepsStateListResponse> getAepsState();
  Future<CommonResponse> onBoardAeps(data);


  //kyc
  Future<EKycResponse> eKycSendOtp(data);
  Future<EKycResponse> eKycResendOtp(data);
  Future<EKycResponse> eKycVerifyOtp(data);
  Future<CommonResponse> eKycAuthenticate(data);


}
