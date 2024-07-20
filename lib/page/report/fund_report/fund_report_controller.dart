import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/money_request_repo.dart';
import 'package:esmartbazaar/data/repo_impl/money_request_impl.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/model/report/summary/summary_credit_card.dart';
import 'package:esmartbazaar/model/report/summary/summary_money_reqeuest.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/fund_report/view_receipt.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class FundRequestReportController extends GetxController
    with ReceiptPrintMixin {
  MoneyRequestRepo moneyRequestRepo = Get.find<MoneyRequestImpl>();

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  bool isPendingRequest = Get.arguments["is_pending"] ?? false;

  var fundRequestReportResponseObs =
      Resource.onInit(data: FundRequestReportResponse()).obs;
  var reportList = <FundRequestReport>[].obs;
  FundRequestReport? previousReport;
  Rx<SummaryMoneyRequestReport?> summaryReport = SummaryMoneyRequestReport().obs;

  var shouldShowSummary = true;

  @override
  void onInit() {
    super.onInit();

    shouldShowSummary = !isPendingRequest;
    if (isPendingRequest) {
      searchStatus = "InComplete";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchReport();
    });
  }

  fetchSummaryReport() async {
    var response = await fetchSummary<SummaryMoneyRequestReport>({
      "fromdate": fromDate,
      "todate": toDate,
      "requestno": searchInput,
      "status": searchStatus,
    }, ReportSummaryType.moneyRequest);
    summaryReport.value = response;
  }

  _fetchReport() async {
   if(shouldShowSummary) fetchSummaryReport();
    try {
      fundRequestReportResponseObs.value = const Resource.onInit();
      final response = await moneyRequestRepo.fetchReport({
        "fromdate": fromDate,
        "todate": toDate,
        "requestno": searchInput,
        "status": searchStatus,
      });
      if (response.code == 1) {
        reportList.value = response.moneyList!;
      }
      fundRequestReportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      fundRequestReportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchInput = "";
    if (isPendingRequest) {
      searchStatus = "InComplete";
    } else {
      searchStatus = "";
    }
    _fetchReport();
  }

  void onItemClick(FundRequestReport report) {
    if (previousReport == null) {
      report.isExpanded.value = true;
      previousReport = report;
    } else if (previousReport! == report) {
      report.isExpanded.value = !report.isExpanded.value;
      previousReport = null;
    } else {
      report.isExpanded.value = true;
      previousReport?.isExpanded.value = false;
      previousReport = report;
    }
  }

  void onSearch() {
    _fetchReport();
  }

  void onUpdateClick(FundRequestReport report) async {
    try {
      StatusDialog.progress();
      final response = await moneyRequestRepo.fetchUpdateInfo({
        "requestid": report.requestId.toString(),
      });

      Get.back();

      if (response.code == 1) {
        Get.toNamed(AppRoute.fundRequestPage, arguments: response)
            ?.then((value) {
          if (value != null) {
            if (value) {
              _fetchReport();
            }
          }
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void onViewReceipt(FundRequestReport report) async {
    Get.dialog(ViewFundReceiptDialog(report: report));
  }
}
