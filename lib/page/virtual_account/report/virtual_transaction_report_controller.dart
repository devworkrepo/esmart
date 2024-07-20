import 'package:get/get.dart';
import 'package:esmartbazaar/model/money_request/bank_dertail.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/fund/component/bond_dialog.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../model/virtual_account/virtual_report.dart';

class VirtualTransactionReportController extends GetxController
    with ReceiptPrintMixin {
  final String tag;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs =
      Resource.onInit(data: VirtualTransactionReportResponse()).obs;
  late List<VirtualTransactionReport> reportList;
  VirtualTransactionReport? previousReport;

  VirtualTransactionReportController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _paramAllReport() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "status": searchStatus,
        };
    _paramPendingReport() => {
      "transaction_no": searchInput,
    };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.virtualAccountAllTag)
          ? await repo.fetchVirtualAllReport(_paramAllReport())
          : await repo.fetchVirtualPendingReport(_paramPendingReport());
      if (response.code == 1) {
        reportList = response.reports!;
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
    fetchReport();
  }

  void onItemClick(VirtualTransactionReport report) {
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

  fetchBond(VirtualTransactionReport data) async {
    try {
      StatusDialog.progress();
      var response = await repo.fetchVirtualBond({"collid": (data.collid ?? "")});
      Get.back();
      if(response.code == 1){
        Get.dialog(BondDialog(data: response.content!, onAccept: (){
          _acceptPayment(data.collid ?? "");
        }, onReject: (){}));
      }
      else{
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _acceptPayment(String id) async{

    try{
      StatusDialog.progress();
      var response = await repo.acceptVirtualPayment({
        "collid" : id
      });
      Get.back();
      if(response.code == 1){
        StatusDialog.success(title: response.message).then((value) => fetchReport());
      }
      else{
        StatusDialog.failure(title: response.message);
      }

    }catch(e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }

  }
}
