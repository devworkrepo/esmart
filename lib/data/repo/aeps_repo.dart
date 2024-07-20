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

abstract class AepsRepo {

  //aeps
  Future<AepsBankResponse> fetchAepsBankList();
  Future<AepsTransactionResponse> aepsTransaction(data);
  Future<AepsTransactionResponse> aadhaaPayTransaction(data);
  Future<CommonResponse> proceedF2FAuth(data);
  Future<CommonResponse> proceedF2FAuthAP(data);


  //aeps settlement
  Future<AepsBalance> fetchAepsBalance();
  Future<CommonResponse> checkF2FAuth();
  Future<CommonResponse> checkF2FAuthAP();
  Future<AepsSettlementCalcResponse> fetchAepsCalc(data);
  Future<BankListResponse> fetchAepsSettlementBank();
  Future<TransactionInfoResponse> spayAccountSettlement(data);
  Future<TransactionInfoResponse> bankAccountSettlement(data);
  Future<AepsSettlementBankListResponse> fetchAepsSettlementBank2();
  Future<CommonResponse> addSettlementBank(data);
  Future<AepsSettlementBankListResponse> deletedBankLists(data);
  Future<CommonResponse> importDeletedAepsBank(data);
  Future<CommonResponse> deleteBankAccount(data);

  //matm

  Future<MatmRequestResponse> initiateMatm(data);
  Future<CommonResponse> updateMatmDataToServer(data);
  Future<MatmCheckTransactionInitiated> isMatmInitiated(data);

  //onbaording
  Future<AepsStateListResponse> getAepsState();
  Future<CommonResponse> onBoardAeps(data);


  //kyc
  Future<EKycResponse> eKycSendOtp(data);
  Future<EKycResponse> eKycResendOtp(data);
  Future<EKycResponse> eKycVerifyOtp(data);
  Future<CommonResponse> eKycAuthenticate(data);


}
