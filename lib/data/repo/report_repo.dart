import 'package:dio/src/cancel_token.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/investment_statement.dart';
import 'package:esmartbazaar/model/investment/investment_withdrawn.dart';
import 'package:esmartbazaar/model/money_request/bank_dertail.dart';
import 'package:esmartbazaar/model/receipt/aeps.dart';
import 'package:esmartbazaar/model/receipt/recharge.dart';
import 'package:esmartbazaar/model/refund/dmt_refund.dart';
import 'package:esmartbazaar/model/report/aeps.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/summary/summary_credit_card.dart';
import 'package:esmartbazaar/model/report/summary/summary_dmt_utility.dart';
import 'package:esmartbazaar/model/report/summary/summary_money_reqeuest.dart';
import 'package:esmartbazaar/model/report/summary/summary_statement.dart';
import 'package:esmartbazaar/model/report/summary/summary_wallet_pay.dart';
import 'package:esmartbazaar/model/report/wallet.dart';
import 'package:esmartbazaar/model/virtual_account/virtual_report.dart';
import '../../model/receipt/credit_card.dart';
import '../../model/receipt/money.dart';
import '../../model/refund/credit_card.dart';
import '../../model/refund/recharge.dart';
import '../../model/report/credit_card.dart';
import '../../model/report/recharge.dart';
import '../../model/report/requery.dart';
import '../../model/report/summary/summary_aeps.dart';
import '../../model/statement/account_statement.dart';
import '../../model/statement/credit_debit_statement.dart';

abstract class ReportRepo{


  //report
  Future<MoneyReportResponse> fetchMoneyTransactionList(data);
  Future<MoneyReportResponse> fetchUPITransactionList(data);
  Future<MoneyReportResponse> fetchPayoutTransactionList(data);
  Future<RechargeReportResponse> fetchRechargeTransactionList(data);
  Future<AepsReportResponse> fetchAepsTransactionList(data);
  Future<AepsReportResponse> fetchMatmTransactionList(data);
  Future<AepsReportResponse> fetchMposTransactionList(data);
  Future<AepsReportResponse> fetchAadhaarTransactionList(data);
  Future<WalletPayReportResponse> fetchWalletPayReport(data);
  Future<CreditCardReportResponse> fetchCreditCardReport(data);
  Future<CommonResponse> rechargeValues();
  Future<InvestmentWithdrawnListResponse> investmentWithdrawnListResponse(data);

  //virtual transaction
  Future<VirtualTransactionReportResponse> fetchVirtualPendingReport(data);
  Future<VirtualTransactionReportResponse> fetchVirtualAllReport(data);
  Future<BondResponse> fetchVirtualBond(data);
  Future<CommonResponse> acceptVirtualPayment(data);

  //refund
  Future<DmtRefundListResponse> dmtRefundList(data);
  Future<DmtRefundListResponse> payoutRefundList(data);
  Future<DmtRefundListResponse> upiRefundList(data);
  Future<RechargeRefundListResponse> rechargeRefundList(data);
  Future<CreditRefundListResponse> creditCardRefundList(data);
  Future<CommonResponse> takeDmtRefund(data);
  Future<CommonResponse> takeUPIRefund(data);
  Future<CommonResponse> takePayoutRefund(data);
  Future<CommonResponse> takeRechargeRefund(data);
  Future<CommonResponse> takeCreditCardRefund(data);

  //re-query
  Future<TransactionInfoResponse> requeryRechargeTransaction(data);
  Future<TransactionInfoResponse> requeryDmtTransaction(data);
  Future<TransactionInfoResponse> requeryUPITransaction(data);
  Future<TransactionInfoResponse> requeryPayoutTransaction(data);
  Future<TransactionInfoResponse> requeryCreditCardTransaction(data);
  Future<TransactionInfoResponse> requeryAepsTransaction(data, {CancelToken? cancelToken});
  Future<TransactionInfoResponse> requeryAadhaarPayTransaction(data);

  //print receipt
  Future<MoneyReceiptResponse> moneyTransactionReceipt(data);
  Future<MoneyReceiptResponse> upiTransactionReceipt(data);
  Future<MoneyReceiptResponse> payoutTransactionReceipt(data);
  Future<RechargeReceiptResponse> rechargeTransactionReceipt(data);
  Future<AepsReceiptResponse> aepsTransactionReceipt(data);
  Future<AepsReceiptResponse> aadhaarPayTransactionReceipt(data);
  Future<CreditCardReceiptResponse> creditCardTransactionReceipt(data);


  //statement
  Future<AccountStatementResponse> fetchAccountStatement(data);
  Future<AccountStatementResponse> fetchAepsStatement(data);
  Future<CreditDebitStatementResponse> fetchCreditStatement(data);
  Future<CreditDebitStatementResponse> fetchDebitStatement(data);
  Future<InvestmentStatementResponse> fetchInvestmentStatement(data);

  //summary report

  Future<SummaryDmtUtilityReport> fetchSummaryDMT(data);
  Future<SummaryDmtUtilityReport> fetchSummaryPayout(data);
  Future<SummaryDmtUtilityReport> fetchSummaryUtility(data);
  Future<SummaryAepsReport> fetchSummaryAeps(data);
  Future<SummaryAepsReport> fetchSummaryAadhaar(data);
  Future<SummaryCreditCardReport> fetchSummaryCreditCard(data);
  Future<SummaryMoneyRequestReport> fetchSummaryMoneyRequest(data);
  Future<SummaryStatementReport> fetchSummaryStatement(data);
  Future<SummaryStatementReport> fetchSummaryStatementAeps(data);
  Future<SummaryWalletPayReport> fetchSummaryWalletPay(data);
  Future<SummaryDmtUtilityReport> fetchSummaryUPI(data);


}