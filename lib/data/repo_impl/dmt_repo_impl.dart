import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/calculate_charge.dart';
import 'package:esmartbazaar/model/dmt/kyc_info.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/model/dmt/sender_kyc.dart';
import 'package:esmartbazaar/model/dmt/verification_charge.dart';
import 'package:esmartbazaar/model/money_request/bank_dertail.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/util/app_util.dart';

class DmtRepoImpl extends DmtRepo {
  final NetworkClient client = Get.find();

  @override
  Future<SenderInfo> searchSender(Map<String, String> data) async {

    var response = await client.post("SearchRemitter", data: data);
    return SenderInfo.fromJson(response.data);
  }  @override
  Future<SenderInfo> searchSenderDmt2(Map<String, String> data) async {

    var response = await client.post("DMT2SearchRemitter", data: data);
    return SenderInfo.fromJson(response.data);
  }

  @override
  Future<DmtBeneficiaryResponse> fetchBeneficiary(data) async {
    var response = await client.post("BeneficiaryList", data: data);
    return DmtBeneficiaryResponse.fromJson(response.data);
  }

  @override
  Future<BankListResponse> fetchBankList() async {

    var response = await client.post("BanksList");
    return BankListResponse.fromJson(response.data);

  }

  @override
  Future<AccountVerifyResponse> verifyAccount(data) async {
    var response = await client.post(
        "VerifyBeneficiary", data: data);
    return AccountVerifyResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addBeneficiary(Map<String, String> data) async {
    var response = await client.post("AddBeneficiary", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistration(Map<String, String> data) async {
    var response = await client.post(
        "RemitterOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistration2(Map<String, String> data) async {
    var response = await client.post(
        "DMT2RemitterOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistrationKyc(Map<String, String> data) async {
    var response = await client.post(
        "DMT2SendereKYC", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistrationOtp(Map<String, String> data) async {
    var response = await client.post(
        "AddRemitter", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistrationOtp2(Map<String, String> data) async {
    var response = await client.post(
        "DMT2AddRemitter", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> transaction(Map<String, String> data) async {
    var response = await client.post("premium-wallet/transaction",data: data);
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<DmtCheckStatusResponse> transactionCheckStatus(Map<String, String> data) async {
    var response = await client.get("transaction/table-check-status",queryParameters: data);
    return DmtCheckStatusResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> beneficiaryDelete(Map<String, String> data) async {
    var response = await client.post("DeleteBeneficiary",data: data);
    return CommonResponse.fromJson(response.data);
  }


  @override
  Future<DmtVerificationChargeResponse> accountVerificationCharge() async {
    var response = await client.get("premium-wallet/get-validation-charge");
    return DmtVerificationChargeResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculateKycCharge(Map<String, String> data) async {
    var response = await client.post("CalcKycCharges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculateKycCharge2(Map<String, String> data) async {
    var response = await client.post("CalcDMT2Charges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculateNonKycCharge(Map<String, String> data)async {
    var response = await client.post("CalcNonKycCharges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderName(data) async{
    var response = await client.post("ChangeSenderName",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderOtp(data) async {
    var response = await client.post("ChangeRemitterOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderMobile(data) async {
    var response = await client.post("ChangeSenderMobile", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AccountSearchResponse> searchAccount(Map<String, String> data) async {
    var response = await client.post("/SearchBeneficiary", data: data);
    return AccountSearchResponse.fromJson(response.data);
  }
@override
  Future<AccountSearchResponse> searchAccountDmt2(Map<String, String> data) async {
    var response = await client.post("/DMT2SearchBeneficiary", data: data);
    return AccountSearchResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> kycTransaction(Map<String, String> data,CancelToken? cancelToken)  async{
    var response = await client.post("/KycTransaction", data: data,cancelToken: cancelToken);
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> dmt2Transaction(Map<String, String> data,CancelToken? cancelToken)  async{
    var response = await client.post("/DMT2Transaction", data: data,cancelToken: cancelToken);
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> nonKycTransaction(Map<String, String> data,CancelToken? cancelToken) async {
    var response = await client.post("/NonKycTransaction", data: data,cancelToken: cancelToken);
    return DmtTransactionResponse.fromJson(response.data);

  }

  @override
  Future<KycInfoResponse> kycInfo(data) async {
    var response = await client.post("/SenderKycDetails", data: data);
    return KycInfoResponse.fromJson(response.data);
  }

  @override
  Future<DmtBeneficiaryResponse> fetchDeletedBeneficiary(Map<String, String> data) async {
    var response = await client.post("/BeneficiaryArchiveList",data: data);
    return DmtBeneficiaryResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> importRemitterBeneficiary(Map<String, String> data) async {
    var response = await client.post("/ImportBeneficiary",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculatePayoutCharge(Map<String, String> data) async {
    var response = await client.post("/CalcPayoutCharges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> payoutTransaction(Map<String, String> data,CancelToken? cancelToken) async {
    var response = await client.post("/PayoutTransaction",data: data, cancelToken: cancelToken);
    return DmtTransactionResponse.fromJson(response.data,);
  }

  @override
  Future<CommonResponse> importDeletedBeneficiary(Map<String, String> data) async {
   var response = await client.post("/ImportArchive",data: data);
   return CommonResponse.fromJson(response.data);
  }

  @override
  Future<BondResponse> fetchPayoutBond()  async{
    var response = await client.post("/GetPayoutBond");
    return BondResponse.fromJson(response.data);
  }

  @override
  Future<SenderKycCaptcha> senderKycCaptcha(data) async {
    var response = await client.post("/GetCaptcha",data: data);
    return SenderKycCaptcha.fromJson(response.data);
  }

  @override
  Future<SenderKycCaptcha> senderKycReCaptcha(data) async {
    var response = await client.post("/GetReCaptcha",data: data);
    return SenderKycCaptcha.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderKycSendOtp(data) async {
    var response = await client.post("/SendEKycOTP",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> sendDmt2TransactionOtp(data) async {
    var response = await client.post("/DMT2TransactionOTP",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderKycReSendOtp(data) async {
    var response = await client.post("/ReSendEKycOTP",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderKycVerifyOtp(data) async {
   var response = await client.post("/VerifyEKycOTP",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> syncBeneficiary(Map<String, String> data) async {
    var response = await client.post("/SyncBeneficiary",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkDmtKycStatus() async {
    var response = await client.post("/KycDmtStatus");
    return CommonResponse.fromJson(response.data);
  }
}
