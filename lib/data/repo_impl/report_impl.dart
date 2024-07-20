import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/investment_statement.dart';
import 'package:esmartbazaar/model/investment/investment_withdrawn.dart';
import 'package:esmartbazaar/model/money_request/bank_dertail.dart';
import 'package:esmartbazaar/model/receipt/aeps.dart';
import 'package:esmartbazaar/model/receipt/recharge.dart';
import 'package:esmartbazaar/model/refund/credit_card.dart';
import 'package:esmartbazaar/model/refund/dmt_refund.dart';
import 'package:esmartbazaar/model/report/aeps.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/summary/summary_aeps.dart';
import 'package:esmartbazaar/model/report/summary/summary_credit_card.dart';
import 'package:esmartbazaar/model/report/summary/summary_dmt_utility.dart';
import 'package:esmartbazaar/model/report/summary/summary_money_reqeuest.dart';
import 'package:esmartbazaar/model/report/summary/summary_statement.dart';
import 'package:esmartbazaar/model/report/summary/summary_wallet_pay.dart';
import 'package:esmartbazaar/model/virtual_account/virtual_report.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/util/api/test_response.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../model/receipt/credit_card.dart';
import '../../model/receipt/money.dart';
import '../../model/refund/recharge.dart';
import '../../model/report/credit_card.dart';
import '../../model/report/recharge.dart';
import '../../model/report/requery.dart';
import '../../model/report/wallet.dart';
import '../../model/statement/account_statement.dart';
import '../../model/statement/credit_debit_statement.dart';

class ReportRepoImpl extends ReportRepo {
  NetworkClient client = Get.find();

  @override
  Future<MoneyReportResponse> fetchMoneyTransactionList(data) async {
    var response = await client.post("/GetTransactionList", data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReportResponse> fetchPayoutTransactionList(data) async {
    var response = await client.post("/GetPayoutList", data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

  @override
  Future<DmtRefundListResponse> dmtRefundList(data) async {
    var response = await client.post("/GetRefundDMTList", data: data);
    return DmtRefundListResponse.fromJson(response.data);
  }

  @override
  Future<DmtRefundListResponse> payoutRefundList(data) async {
    var response = await client.post("/GetRefundPayoutList", data: data);
    return DmtRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeDmtRefund(data) async {
    var response = await client.post("/ClaimDMTRefund", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takePayoutRefund(data) async {
    var response = await client.post("/ClaimPayoutRefund", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<RechargeReportResponse> fetchRechargeTransactionList(data) async {
    var response = await client.post("/GetRechagesList", data: data);
    return RechargeReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchAepsTransactionList(data) async {
    var response = await client.post("/AEPSTransactionList", data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchMatmTransactionList(data) async {
    var response = await client.post("/MatmTransactionList", data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchMposTransactionList(data) async {
    var response = await client.post("/MPosTransactionList", data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchAadhaarTransactionList(data) async {
    var response = await client.post("/AadharPayTransactionList", data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AccountStatementResponse> fetchAccountStatement(data) async {
    var response = await client.post("/GetAccountStatement", data: data);
    return AccountStatementResponse.fromJson(response.data);
  }

  @override
  Future<AccountStatementResponse> fetchAepsStatement(data) async {
    var response = await client.post("/GetAepsStatement", data: data);
    return AccountStatementResponse.fromJson(response.data);
  }

  @override
  Future<CreditDebitStatementResponse> fetchCreditStatement(data) async {
    var response = await client.post("/GetCrDrList", data: data);
    return CreditDebitStatementResponse.fromJson(response.data);
  }

  @override
  Future<CreditDebitStatementResponse> fetchDebitStatement(data) async {
    var response = await client.post("/GetCrDrList", data: data);
    return CreditDebitStatementResponse.fromJson(response.data);
  }

  @override
  Future<WalletPayReportResponse> fetchWalletPayReport(data) async {
    var response = await client.post("/GetWalletList", data: data);
    return WalletPayReportResponse.fromJson(response.data);
  }

  @override
  Future<RechargeRefundListResponse> rechargeRefundList(data) async {
    var response = await client.post("/GetRefundRechagesList", data: data);
    return RechargeRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeRechargeRefund(data) async {
    var response = await client.post("/ClaimRechargeRefund", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryDmtTransaction(data) async {
    var response = await client.post("/RequeryTransaction", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryPayoutTransaction(data) async {
    var response = await client.post("/RequeryPayout", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<CreditCardReportResponse> fetchCreditCardReport(data) async {
    var response = await client.post("/GetCreditTransactionList", data: data);
    return CreditCardReportResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryCreditCardTransaction(data) async {
    var response = await client.post("/RequeryCreditTransaction", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<CreditRefundListResponse> creditCardRefundList(data) async {
    var response = await client.post("/GetRefundCreditList", data: data);
    return CreditRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeCreditCardRefund(data) async {
    var response = await client.post("/ClaimCreditCardRefund", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> rechargeValues() async {
    var response = await client.post("/GetRechValues");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReceiptResponse> moneyTransactionReceipt(data) async {
    var response = await client.post("/GetTransactionInfo", data: data);
    return MoneyReceiptResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReceiptResponse> payoutTransactionReceipt(data) async {
    var response = await client.post("/GetPayoutInfo", data: data);
    return MoneyReceiptResponse.fromJson(response.data);
  }

  @override
  Future<RechargeReceiptResponse> rechargeTransactionReceipt(data) async {
    var response = await client.post("/GetRechagesInfo", data: data);
    return RechargeReceiptResponse.fromJson(response.data);
  }

  @override
  Future<AepsReceiptResponse> aepsTransactionReceipt(data) async {
    var response = await client.post("/GetAEPSInfo", data: data);
    return AepsReceiptResponse.fromJson(response.data);
  }

  @override
  Future<AepsReceiptResponse> aadhaarPayTransactionReceipt(data) async {
    var response = await client.post("/GetAadharPayInfo", data: data);
    return AepsReceiptResponse.fromJson(response.data);
  }

  @override
  Future<CreditCardReceiptResponse> creditCardTransactionReceipt(data) async {
    var response = await client.post("/GetCreditCardInfo", data: data);
    return CreditCardReceiptResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryRechargeTransaction(data) async {
    var response = await client.post("/RequeryUtility", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryAadhaarPayTransaction(data) async {
    var response = await client.post("/RequeryAadharPay", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryAepsTransaction(data,
      {CancelToken? cancelToken, int? type}) async {
    var response =
        await client.post("/RequeryAEPS", data: data, cancelToken: cancelToken);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<VirtualTransactionReportResponse> fetchVirtualAllReport(data) async {
    var response = await client.post("/VirtualTransList", data: data);
    return VirtualTransactionReportResponse.fromJson(response.data);
  }

  @override
  Future<VirtualTransactionReportResponse> fetchVirtualPendingReport(
      data) async {
    var response = await client.post("/VirtualTransPending", data: data);
    return VirtualTransactionReportResponse.fromJson(response.data);
  }

  @override
  Future<BondResponse> fetchVirtualBond(data) async {
    var response = await client.post("/GetVirtualBond", data: data);
    return BondResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> acceptVirtualPayment(data) async {
    var response = await client.post("/AcceptVirtualPayment", data: data);
    return CommonResponse.fromJson(response.data);
  }








  ////////////////////////summary///////////////////////////////////////////////
  @override
  Future<SummaryAepsReport> fetchSummaryAadhaar(data) async {
    var response = await client.post("/GetSummary_Aadhar", data: data);
    return SummaryAepsReport.fromJson(response.data);
  }

  @override
  Future<SummaryAepsReport> fetchSummaryAeps(data) async {
    var response = await client.post("/GetSummary_Aeps", data: data);
    return SummaryAepsReport.fromJson(response.data);
  }

  @override
  Future<SummaryCreditCardReport> fetchSummaryCreditCard(data) async{
    var response = await client.post("/GetSummary_CreditCard", data: data);
    return SummaryCreditCardReport.fromJson(response.data);
  }

  @override
  Future<SummaryDmtUtilityReport> fetchSummaryDMT(data) async{
    var response = await client.post("/GetSummary_Dmt", data: data);
    return SummaryDmtUtilityReport.fromJson(response.data);
  }

  @override
  Future<SummaryMoneyRequestReport> fetchSummaryMoneyRequest(data)async {
    var response = await client.post("/GetSummary_MoneyRequest", data: data);
    return SummaryMoneyRequestReport.fromJson(response.data);
  }

  @override
  Future<SummaryDmtUtilityReport> fetchSummaryPayout(data) async{
    var response = await client.post("/GetSummary_Payout", data: data);
    return SummaryDmtUtilityReport.fromJson(response.data);
  }

  @override
  Future<SummaryStatementReport> fetchSummaryStatement(data) async{
    var response = await client.post("/GetSummary_Statement", data: data);
    return SummaryStatementReport.fromJson(response.data);
  }

  @override
  Future<SummaryStatementReport> fetchSummaryStatementAeps(data)async {
    var response = await client.post("/GetSummary_StatementAeps", data: data);
    return SummaryStatementReport.fromJson(response.data);
  }

  @override
  Future<SummaryDmtUtilityReport> fetchSummaryUtility(data) async{
    var response = await client.post("/GetSummary_Utility", data: data);
    return SummaryDmtUtilityReport.fromJson(response.data);
  }

  @override
  Future<SummaryWalletPayReport> fetchSummaryWalletPay(data) async {
    var response = await client.post("/GetSummary_WalletPay", data: data);
    return SummaryWalletPayReport.fromJson(response.data);
  }

  @override
  Future<InvestmentStatementResponse> fetchInvestmentStatement(data) async {
   var response = await client.post("/GetInvestStatement", data: data);
    return InvestmentStatementResponse.fromJson(response.data);

  }

  @override
  Future<InvestmentWithdrawnListResponse> investmentWithdrawnListResponse(data) async {
     var response = await client.post("/GetInvestPayList", data: data);
     return InvestmentWithdrawnListResponse.fromJson(response.data);

  }

  @override
  Future<SummaryDmtUtilityReport> fetchSummaryUPI(data) async {
    var response = await client.post("/NA", data: data);
    return SummaryDmtUtilityReport.fromJson(response.data);
  }

  @override
  Future<MoneyReportResponse> fetchUPITransactionList(data) async{
    var response = await client.post("/GetTransactionListUPI", data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryUPITransaction(data) async{
    var response = await client.post("/RequeryTransactionUPI", data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReceiptResponse> upiTransactionReceipt(data) async{
    var response = await client.post("/GetTransactionInfoUPI", data: data);
    return MoneyReceiptResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeUPIRefund(data) async {
    var response = await client.post("/ClaimUPIRefund", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<DmtRefundListResponse> upiRefundList(data) async {
    var response = await client.post("/GetRefundUPIList", data: data);
    return DmtRefundListResponse.fromJson(response.data);
  }

}
