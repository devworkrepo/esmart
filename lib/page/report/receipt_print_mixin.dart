import 'dart:io';

import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/receipt/aeps.dart';
import 'package:esmartbazaar/model/receipt/credit_card.dart';
import 'package:esmartbazaar/model/receipt/money.dart';
import 'package:esmartbazaar/model/receipt/recharge.dart';
import 'package:esmartbazaar/page/pdf_html/aeps_receipt_html.dart';
import 'package:esmartbazaar/page/pdf_html/credit_card_receipt_html.dart';
import 'package:esmartbazaar/page/pdf_html/dmt_receipt_html.dart';
import 'package:esmartbazaar/page/pdf_html/recharge_receipt_html.dart';

enum ReceiptType {
  money,
  payout,
  recharge,
  aeps,
  aadhaarPay,
  matm,
  mpos,
  creditCard,
  upi
}
enum ReportSummaryType {
  dmt,
  payout,
  utility,
  aeps,
  aadhaar,
  creditCard,
  moneyRequest,
  statement,
  statementAeps,
  walletPay,
  upi
}

mixin ReceiptPrintMixin {


  void postNewComplaint(Map<String,String> param){
    Get.toNamed(AppRoute.complainPostPage,arguments: param);
  }

  ReportRepo repo = Get.find<ReportRepoImpl>();

  void printReceipt(String calcId, ReceiptType receiptType) {
    var mParamTag =
    (receiptType == ReceiptType.money || receiptType == ReceiptType.payout || receiptType == ReceiptType.upi)
        ? "calcid"
        : "transaction_no";
    var _param = {mParamTag: calcId};
    switch (receiptType) {
      case ReceiptType.money:
        _fetchDmtReceiptData(_param, receiptType);
        break;
      case ReceiptType.payout:
        _fetchDmtReceiptData(_param, receiptType);
        break;
      case ReceiptType.recharge:
        _fetchRechargeReceiptData(_param, receiptType);
        break;
      case ReceiptType.aeps:
        _fetchAepsReceiptData(_param, receiptType);
        break;
      case ReceiptType.aadhaarPay:
        _fetchAadhaarPayReceiptData(_param, receiptType);
        break;
      case ReceiptType.matm:
        _fetchAepsReceiptData(_param, receiptType);
        break;
      case ReceiptType.mpos:
        _fetchAepsReceiptData(_param, receiptType);
        break;
      case ReceiptType.creditCard:
        _fetchCreditCardReceiptData(_param, receiptType);
        break;
      case ReceiptType.upi:
        _fetchUpiReceiptData(_param, receiptType);
        break;
    }
  }

  Future<T?> fetchSummary<T>(
      Map<String, String> param, ReportSummaryType summaryType) async {
    try {
      switch (summaryType) {
        case ReportSummaryType.dmt:
          var response = await repo.fetchSummaryDMT(param);
          return response as T;
        case ReportSummaryType.payout:
          var response = await repo.fetchSummaryPayout(param);
          return response as T;
        case ReportSummaryType.utility:
          var response = await repo.fetchSummaryUtility(param);
          return response as T;
        case ReportSummaryType.aeps:
          var response = await repo.fetchSummaryAeps(param);
          return response as T;
        case ReportSummaryType.aadhaar:
          var response = await repo.fetchSummaryAadhaar(param);
          return response as T;
        case ReportSummaryType.creditCard:
          var response = await repo.fetchSummaryCreditCard(param);
          return response as T;
        case ReportSummaryType.moneyRequest:
          var response = await repo.fetchSummaryMoneyRequest(param);
          return response as T;
        case ReportSummaryType.statement:
          var response = await repo.fetchSummaryStatement(param);
          return response as T;
        case ReportSummaryType.statementAeps:
          var response = await repo.fetchSummaryStatementAeps(param);
          return response as T;
        case ReportSummaryType.walletPay:
          var response = await repo.fetchSummaryWalletPay(param);
          return response as T;
        case ReportSummaryType.upi:
          var response = await repo.fetchSummaryWalletPay(param);
          return response as T;
      }
    } catch (e) {
      return null;
    }
  }

  _fetchDmtReceiptData(param, ReceiptType receiptType) async {
    var response = (receiptType == ReceiptType.money)
        ? await _fetchHelper<MoneyReceiptResponse>(
        repo.moneyTransactionReceipt(param))
        : await _fetchHelper<MoneyReceiptResponse>(
        repo.payoutTransactionReceipt(param));
    if (response == null) return;
    _printPdfData(MoneyReceiptHtmlData(response).printData());
  }

  _fetchRechargeReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<RechargeReceiptResponse>(
        repo.rechargeTransactionReceipt(param));
    if (response == null) return;
    _printPdfData(RechargeReceiptHtmlData(response).printData());
  }

  _fetchAepsReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<AepsReceiptResponse>(
        repo.aepsTransactionReceipt(param));
    if (response == null) return;

    if (receiptType == ReceiptType.matm) {
      _printPdfData(AepsReceiptHtmlData(response, "Micro-ATM").printData());
    } else if (receiptType == ReceiptType.mpos) {
      _printPdfData(AepsReceiptHtmlData(response, "MPOS").printData());
    } else {
      _printPdfData(AepsReceiptHtmlData(response, "AEPS").printData());
    }
  }

  _fetchAadhaarPayReceiptData(param, ReceiptType type) async {
    var response = await _fetchHelper<AepsReceiptResponse>(
        repo.aadhaarPayTransactionReceipt(param));
    if (response == null) return;
    _printPdfData(AepsReceiptHtmlData(response, "Aadhaar Pay").printData());
  }

  _fetchCreditCardReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<CreditCardReceiptResponse>(
        repo.creditCardTransactionReceipt(param));
    if (response == null) return;

    _printPdfData(CreditCardReceiptHtmlData(response).printData());
  }

  _fetchUpiReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<MoneyReceiptResponse>(
        repo.upiTransactionReceipt(param));
    if (response == null) return;

    _printPdfData(MoneyReceiptHtmlData(response).printData());
  }

  _printPdfData(String printData) async {
    try {
      var filePath = await generateReceiptDpfDocument(printData);
      OpenFile.open(filePath);
    } catch (e) {
      StatusDialog.failure(title: e.toString());
    }
  }

  Future<String> generateReceiptDpfDocument(String htmlContent) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final targetPath = appDocDir.path;
      const targetFileName = "esmart-bazaar-receipt.pdf";

      final _flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();

      final generatedPdfFile =
      await _flutterNativeHtmlToPdfPlugin.convertHtmlToPdf(
        html: htmlContent,
        targetDirectory: targetPath,
        targetName: targetFileName,
      );

      return  generatedPdfFile!.path;


    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<T?> _fetchHelper<T>(Future call) async {
    try {
      StatusDialog.progress();
      dynamic response = await call;
      Get.back();
      if (response.code == 1) {
        return response as T;
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
        return null;
      }
    } catch (e) {
      Get.back();
      StatusDialog.failure(title: "Something went wrong!!");
      return null;
    }
  }
}
