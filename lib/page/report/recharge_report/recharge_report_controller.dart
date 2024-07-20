import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/recharge.dart';
import 'package:esmartbazaar/model/report/summary/summary_dmt_utility.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';

import '../../../widget/dialog/status_dialog.dart';
import '../report_helper.dart';

class RechargeReportController extends GetxController with ReceiptPrintMixin{
  ReportRepo repo = Get.find<ReportRepoImpl>();

  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";
  String rechargeType = "";

  var reportResponseObs = Resource.onInit(data: RechargeReportResponse()).obs;
  var  reportList = <RechargeReport>[].obs;

  Rx<SummaryDmtUtilityReport?> summaryReport = SummaryDmtUtilityReport().obs;

  RechargeReport? previousReport;

  RechargeReportController(this.origin);

  @override
  void onInit() {
    super.onInit();
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchRechargeValue();
      fetchReport();
    });
  }

  fetchRechargeValue() async {
    repo.rechargeValues();
  }

  fetchSummaryReport() async{

    var response = await fetchSummary<SummaryDmtUtilityReport>({
      "fromdate": fromDate,
      "todate": toDate,
      "transaction_no": searchInput,
      "status": searchStatus,
      "rech_type": rechargeType,
    }, ReportSummaryType.utility);
    summaryReport.value = response;


  }

  fetchReport() async {
    fetchSummaryReport();
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "status": searchStatus,
          "rech_type": rechargeType,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchRechargeTransactionList(_param());
      if (response.code == 1) {
        reportList.value = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    rechargeType="";
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fetchReport();
  }


  void requeryTransaction(RechargeReport report) async {
    try{
      StatusDialog.progress();
      var response =  await repo.requeryRechargeTransaction({
        "transaction_no": report.transactionNumber ?? "",
      });

      Get.back();
      if (response.code == 1) {
        ReportHelperWidget.requeryStatus(response.trans_response ?? "InProgress",
            response.trans_response ?? "Message not found", () {
              fetchReport();
            });
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong");
      }
    }catch(e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void onItemClick(RechargeReport report) {
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
    fetchReport();
  }

}
