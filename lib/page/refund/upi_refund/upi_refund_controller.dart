import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/report_repo.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/refund/dmt_refund.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import '../../../util/security/encription.dart';

class UpiRefundController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();


  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var moneyReportResponseObs =
      Resource.onInit(data: DmtRefundListResponse()).obs;
  late List<DmtRefund> moneyReportList;
  DmtRefund? previousReport;

  UpiRefundController();

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  void takeDmtRefund(String mPin, DmtRefund report) async {
    StatusDialog.progress();
    var response =  await repo.takeUPIRefund({
      "transaction_no": report.transactionNumber ?? "",
      "mpin": Encryption.encryptMPIN(mPin),
    });

    Get.back();
    if (response.code == 1) {
      StatusDialog.success(title: response.message)
          .then((value) => fetchReport());
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,

        };

    try {
      moneyReportResponseObs.value = const Resource.onInit();
      final response =  await repo.upiRefundList(_param());
      if (response.code == 1) {
        moneyReportList = response.list!;
      }
      moneyReportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      moneyReportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchInput = "";
    fetchReport();
  }

  void onItemClick(DmtRefund report) {
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
