import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/investment/investment_withdrawn.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/summary/summary_dmt_utility.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';

class InvestmentWithdrawnController extends GetxController with ReceiptPrintMixin {


  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";
  String searchInput2 = "";
  var showFabObs = false.obs;

  var reportResponseObs = Resource.onInit(data: InvestmentWithdrawnListResponse()).obs;
  InvestmentWithdrawnListItem? previousReport;

  @override
  void onInit() {
    super.onInit();

    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "investrefno": searchInput2,
          "status": searchStatus,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response =  await repo.investmentWithdrawnListResponse(_param());
      if (response.code == 1) {
        if(response.reports!.isNotEmpty) {
          showFabObs.value = false;
        }
        else{
          showFabObs.value = true;
        }
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
    searchInput2 = "";

    fetchReport();
  }

  void onItemClick(InvestmentWithdrawnListItem report) {
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
