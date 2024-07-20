import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/model/report/recharge.dart';
import 'package:esmartbazaar/model/statement/credit_debit_statement.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class CreditDebitController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchInput = "";
  String status = "";
  String serviceType = "";

  var reportResponseObs = Resource
      .onInit(data: CreditDebitStatementResponse())
      .obs;
  late List<CreditDebitStatement> reportList;
  CreditDebitStatement? previousReport;

  final String tag;

  CreditDebitController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "refno": searchInput,
          "status": status,
          "amttype": serviceType
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.creditStatementControllerTag)
          ? await repo.fetchCreditStatement(_param())
          : await repo.fetchDebitStatement(_param());
      if (response.code == 1) {
        reportList = response.reportList!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate =
        DateUtil.currentDateInYyyyMmDd(dayBefore: (kDebugMode) ? 30 : null);
    searchInput = "";
    fetchReport();
  }


  void onSearch() {
    fetchReport();
  }

  String getServiceType() {
    if (serviceType == "") {
      return "All";
    } else {
       return serviceType;
    }
  }

  void setServiceType(String type) {
    if (type == "All") {
      serviceType = "";
    } else {
      serviceType = type;
    }
  }
}
