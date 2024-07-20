import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/report/security_deposit.dart';
import 'package:esmartbazaar/model/report/wallet.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';

class SecurityDepositReportController extends GetxController {
  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  String fromDate = "";
  String toDate = "";
  String status = "";
  String mobileNumber = "";
  String transactionNumber = "";

  var reportResponseObs =
      Resource.onInit(data: SecurityDepositReportResponse()).obs;
  late List<SecurityDepositReport> reportList;
  SecurityDepositReport? previousReport;

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    _fetchReport();
  }

  _fetchReport() async {
    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchReport({
        "fromdate": fromDate,
        "todate": toDate,
        "transaction_no": transactionNumber,
        "mobileno": mobileNumber,
        "status": status,
      });
      if (response.code == 1) {
        if(response.translist !=null) {
          reportList = response.translist!;
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
    _fetchReport();
  }

  void onItemClick(SecurityDepositReport report) {
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
}
