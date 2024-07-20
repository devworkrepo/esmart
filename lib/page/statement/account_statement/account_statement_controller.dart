import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/recharge.dart';
import 'package:esmartbazaar/model/report/summary/summary_statement.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class AccountStatementController extends GetxController with ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";

  AppPreference appPreference = Get.find();

  var reportResponseObs = Resource
      .onInit(data: AccountStatementResponse())
      .obs;
  var reportList =<AccountStatement>[].obs;
  Rx<SummaryStatementReport?> summaryReport = SummaryStatementReport().obs;

  AccountStatement? previousReport;

  final String tag;

  AccountStatementController(this.tag);

  @override
  void onInit() {
    super.onInit();

    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchSummaryReport() async{

    ReportSummaryType type;
    if(tag == AppTag.aepsStatementControllerTag){
      type = ReportSummaryType.statementAeps;
    }
    else{
      type = ReportSummaryType.statement;
    }

    var response = await fetchSummary<SummaryStatementReport>({
      "fromdate": fromDate,
      "todate": toDate,
    }, type);
    summaryReport.value = response;


  }


  fetchReport() async {
    fetchSummaryReport();
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.accountStatementControllerTag)
          ? await repo.fetchAccountStatement(_param())
          : await repo.fetchAepsStatement(_param());
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
    fetchReport();
  }

  void onItemClick(AccountStatement report) {
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
