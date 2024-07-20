import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/money_request_repo.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/model/money_request/bank_dertail.dart';
import 'package:esmartbazaar/model/money_request/update_detail.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:dio/dio.dart' as dio;

import '../../model/money_request/pg_charge.dart';
import '../../model/money_request/pg_initiate.dart';
import '../../model/money_request/pg_payment_mode.dart';

class MoneyRequestImpl extends MoneyRequestRepo{

  NetworkClient client = Get.find();


  @override
  Future<BankTypeDetailResponse> fetchBankType()  async{
    var response = await client.post("/GetMoneyMasters");
    return BankTypeDetailResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> makeRequest(dio.FormData data) async {
    var response = await client.post("/AddMoneyRequest",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<BondResponse> requestBond(dio.FormData data) async {

    var response = await client.post("/GetMoneyRequestBond",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return BondResponse.fromJson(response.data);
  }

  @override
  Future<FundRequestReportResponse> fetchReport(data) async {
    var response = await client.post("/MoneyRequestList",data: data);
    return FundRequestReportResponse.fromJson(response.data);
  }

  @override
  Future<MoneyRequestUpdateResponse> fetchUpdateInfo(data) async {
    var response = await client.post("/MoneyRequestDetails",data: data);
    return MoneyRequestUpdateResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> updateRequest(dio.FormData data) async {
    var response = await client.post("/UpdateMoneyRequest",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }


  @override
  Future<PgPaymentModeResponse> fetchPgPaymentList(data) async {
    var response = await client.post("/PgChargesList",data: data);
    return PgPaymentModeResponse.fromJson(response.data);
  }

  @override
  Future<PgChargeResponse> fetchPgCharge(data) async {
    var response = await client.post("/CalcPgCharges",data: data);
    return PgChargeResponse.fromJson(response.data);
  }

  @override
  Future<PgInitiateResponse> initiatePaymentGateway(data) async {
    var response = await client.post("/AddPGTransaction",data: data);
    return PgInitiateResponse.fromJson(response.data);
  }

}