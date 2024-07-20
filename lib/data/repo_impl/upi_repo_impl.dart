import 'package:dio/dio.dart';
import 'package:esmartbazaar/model/dmt/upi_bank_list.dart';
import 'package:esmartbazaar/model/dmt/upi_mobile_search.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
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

class UpiRepoImpl extends UpiRepo {
  final NetworkClient client = Get.find();

  @override
  Future<SenderInfo> searchSender(Map<String, String> data) async {

    var response = await client.post("SearchRemitter", data: data);
    return SenderInfo.fromJson(response.data);
  }

  @override
  Future<AccountSearchResponse> searchAccount(Map<String, String> data) async {
    var response = await client.post("SearchBeneficiaryUPI", data: data);
    return AccountSearchResponse.fromJson(response.data);
  }


  @override
  Future<AccountVerifyResponse> verifyAccount(data) async {
    var response = await client.post(
        "VerifyBeneficiaryupi", data: data);
    return AccountVerifyResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addBeneficiary(data) async {
    var response = await client.post("AddBeneficiaryUPI", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistration(data) async {
    var response = await client.post("AddRemitterupi", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistrationOtp(data) async {
    var response = await client.post("VerifyRemitterupi", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<DmtBeneficiaryResponse> fetchBeneficiary(data) async {
    var response = await client.post("BeneficiaryListUPI", data: data);
    return DmtBeneficiaryResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> beneficiaryDelete(data) async {
    // TODO: implement beneficiaryDelete
    throw UnimplementedError();
  }

  @override
  Future<CalculateChargeResponse> calculatePayoutUpiCharge(data) async {
    var response = await client.post("CalcUPICharges", data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> transaction(data,CancelToken? cancelToken) async {
    var response = await client.post("UPITransaction", data: data);
   // final response = await AppUtil.parseJsonFromAssets("upi_transaction");
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<UpiBankListResponse> upiBankList()  async{
    var response = await client.post("BanksListUPI");
    return UpiBankListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> fetchTransactionNumber() async {
    var response = await client.post("/GetTransactionNo");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<UpiMobileUpiResponse> searchUpiListWithMobile(data) async {

    var response = await client.post("/VerifyBeneficiaryUPIMobile",data: data);
    return UpiMobileUpiResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> transactionDirect(data, CancelToken? cancelToken) async {
    var response = await client.post("UPITransactionDirect", data: data);
    return DmtTransactionResponse.fromJson(response.data);
  }
}
