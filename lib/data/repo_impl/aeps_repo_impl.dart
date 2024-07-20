import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/aeps/kyc/e_kyc.dart';
import 'package:esmartbazaar/model/aeps/settlement/aeps_calc.dart';
import 'package:esmartbazaar/model/aeps/settlement/balance.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/report/requery.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../model/aeps/aeps_state.dart';
import '../../model/matm/matm_request_response.dart';

class AepsRepoImpl extends AepsRepo {
  NetworkClient client = Get.find();

  @override
  Future<AepsBankResponse> fetchAepsBankList() async {
    var response = await client.post("/GetAEPSBanks");
    return AepsBankResponse.fromJson(response.data);
  }

  @override
  Future<AepsTransactionResponse> aepsTransaction(data) async {
    var response = await client.post("/AEPSTransaction", data: data);
    return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<MatmRequestResponse> initiateMatm(data) async {
    var response = await client.post("/MatmTransactionRequest", data: data);
    return MatmRequestResponse.fromJson(response.data);
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
    var response = await client.post("/OnBoardAEPS", data: data);
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
  Future<CommonResponse> updateMatmDataToServer(data) async {
    var response = await client.post("/MatmTransactionUpdate", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AepsBalance> fetchAepsBalance() async {
    var response = await client.post("/CheckAEPSBalance");
    return AepsBalance.fromJson(response.data);
  }

  @override
  Future<BankListResponse> fetchAepsSettlementBank() async {
    var response = await client.post("/GetWithdrawBanks");
    return BankListResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> bankAccountSettlement(data) async {
    var response = await client.post("/WithdrawAEPSInBank", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> spayAccountSettlement(data) async {
    var response = await client.post("/WithdrawAEPSInWallet", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<AepsTransactionResponse> aadhaaPayTransaction(data) async {
    var response = await client.post("/AadharPayTransaction", data: data);
    return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<MatmCheckTransactionInitiated> isMatmInitiated(data) async {
    var url = "https://www.comrade.tramo.in/matm/spay/is-transaction-initiated";
    var response = await Dio().get(url, queryParameters: data);
    return MatmCheckTransactionInitiated.fromJson(response.data);
  }

  @override
  Future<AepsSettlementBankListResponse> fetchAepsSettlementBank2() async {
    var response = await client.post("/GetAEPSSettleBanks");
    return AepsSettlementBankListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addSettlementBank(data) async {
    var response = await client.post("/AddAEPSBank",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AepsSettlementBankListResponse> deletedBankLists(data) async {
    var response = await client.post("/GetDeletedSettleBanks",data: data);
    return AepsSettlementBankListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> importDeletedAepsBank(data) async {
    var response = await client.post("/ImportAEPSBank",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> deleteBankAccount(data) async {
    var response = await client.post("/DeleteAEPSBank",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AepsSettlementCalcResponse> fetchAepsCalc(data) async {
    var response = await client.post("/CalcChargesAEPSBank",data: data);
    return AepsSettlementCalcResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkF2FAuth() async{
    var response = await client.post("/CheckAuthStatus");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> proceedF2FAuth(data) async {
    var response = await client.post("/AepsDailyAuth",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkF2FAuthAP() async {
    var response = await client.post("/CheckAuthStatusAP");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> proceedF2FAuthAP(data) async {
    var response = await client.post("/AepsDailyAuthAP",data: data);
    return CommonResponse.fromJson(response.data);
  }
}
