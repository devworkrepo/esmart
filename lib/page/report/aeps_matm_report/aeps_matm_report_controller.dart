import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/report/summary/summary_aeps.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import '../../../model/report/aeps.dart';
import '../../../widget/dialog/status_dialog.dart';
import '../report_helper.dart';

class AepsMatmReportController extends GetxController with ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: AepsReportResponse()).obs;
  var reportList = <AepsReport>[].obs;
  AepsReport? previousReport;

  final String tag;

  Rx<SummaryAepsReport?> summaryReport = SummaryAepsReport().obs;

  AepsMatmReportController(this.tag, this.origin);
  String serviceType = "";

  @override
  void onInit() {
    super.onInit();
    if (origin == "summary") {
      searchStatus = "InProgress";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchSummaryReport() async {

    var param = {
      "fromdate": fromDate,
      "todate": toDate,
      "transaction_no": searchInput,
      "status": searchStatus,
      "service_type": serviceType
    };
    var response = /*(serviceType == "")
        ? await fetchSummary<SummaryAepsReport>(param, ReportSummaryType.aadhaar)
        : */await fetchSummary<SummaryAepsReport>(param, ReportSummaryType.aeps);

    summaryReport.value = response;
  }

  fetchReport() async {
    fetchSummaryReport();

    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "status": searchStatus,
          "service_type" : serviceType
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.aepsReportControllerTag)
          ? await repo.fetchAepsTransactionList(_param())
          : (tag == AppTag.aadhaarPayReportControllerTag)
              ? await repo.fetchAadhaarTransactionList(_param())
              : (tag == AppTag.matmReportControllerTag)
                  ? await repo.fetchMatmTransactionList(_param())
                  : await repo.fetchMposTransactionList(_param());
      if (response.code == 1) {
        reportList.value = response.reportList!;
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
    if (origin == "summary") {
      searchStatus = "InProgress";
    }
    fetchReport();
  }

  void onItemClick(AepsReport report) {
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

  void requeryTransaction(AepsReport report) async {
    try {
      StatusDialog.progress();
      var response = (tag == AppTag.aadhaarPayReportControllerTag)
          ? await repo.requeryAadhaarPayTransaction({
              "transaction_no": report.transactionNumber ?? "",
            })
          : await repo.requeryAepsTransaction({
              "transaction_no": report.transactionNumber ?? "",
            });

      Get.back();
      if (response.code == 1) {
        ReportHelperWidget.requeryStatus(response.trans_status ?? "InProgress",
            response.trans_response ?? "Message not found", () {
          fetchReport();
        });
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void onSearch() {
    fetchReport();
  }

  String getServiceType(){
    if(serviceType == "") {
      return "All";
    } else {
      return serviceType;
    }
  }

  void setServiceType(String type) {
    if(type == "All") {
      serviceType = "";
    } else {
      serviceType = type;
    }

  }
}
