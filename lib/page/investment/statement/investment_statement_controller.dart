import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/investment/investment_list.dart';
import 'package:esmartbazaar/model/investment/investment_statement.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/recharge.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class InvestmentStatementController extends GetxController  {
  ReportRepo repo = Get.find<ReportRepoImpl>();
  InvestmentListItem item = Get.arguments["item"]!;

  String fromDate = "";
  String toDate = "";

  var reportResponseObs = Resource.onInit(data: InvestmentStatementResponse()).obs;
  InvestmentStatement? previousReport;
  var showFabObs = false.obs;

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

    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "fdid": item.fdid.toString(),
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response =  await repo.fetchInvestmentStatement(_param());
      if (response.code == 1) {
        if(response.reportList!.isNotEmpty) {
          showFabObs.value = false;
        }
        else{
          showFabObs.value = true;
        }
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      print("HelloDev : "+e.toString());
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  void onItemClick(InvestmentStatement report) {
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
