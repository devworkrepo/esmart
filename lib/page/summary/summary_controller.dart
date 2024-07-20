import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:esmartbazaar/page/refund/credit_card_refund/credit_card_refund_page.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_page.dart';
import 'package:esmartbazaar/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:esmartbazaar/page/refund/recharge_refund/recharge_refund_page.dart';
import 'package:esmartbazaar/page/refund/refund_tab.dart';
import 'package:esmartbazaar/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:esmartbazaar/page/report/aeps_matm_report/aeps_matm_report_page.dart';
import 'package:esmartbazaar/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:esmartbazaar/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:esmartbazaar/page/report/money_report/money_report_page.dart';
import 'package:esmartbazaar/page/report/recharge_report/recharge_report_controller.dart';
import 'package:esmartbazaar/page/report/recharge_report/recharge_report_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';

import '../../model/summary.dart';
import '../../util/tags.dart';
import '../report/money_report/money_report_controller.dart';

class SummaryController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var responseObs = Resource.onInit(data: TransactionSummary()).obs;
  late TransactionSummary summary;

  AppPreference appPreference = Get.find();


  fetchSummary() async {
    ObsResponseHandler<TransactionSummary>(
        obs: responseObs,
        apiCall: repo.fetchSummary(),
        result: (data) {
          summary = data;
        });
  }

  onDmtInProgressClick() {
    Get.delete<MoneyReportController>(tag: AppTag.moneyReportControllerTag);
    Get.to(() => const MoneyReportPage(
        controllerTag: AppTag.moneyReportControllerTag, origin: "summary"));
  }

  onDmtInRefundPendingClick() {
    Get.delete<DmtRefundController>(tag: AppTag.moneyRefundControllerTag);
    Get.to(() => const DmtRefundPage(
        controllerTag: AppTag.moneyRefundControllerTag, origin: "summary"));
  }

  onUtilityInProgressClick() {
    Get.delete<RechargeReportController>();
    Get.to(() => const RechargeReportPage(origin: "summary"));
  }

  onUtilityInRefundPendingClick() {
    Get.delete<RechargeRefundController>();
    Get.to(() => const RechargeRefundPage(origin: "summary"));
  }

  onCreditCardInProgressClick() {
    Get.delete<CreditCardReportController>();
    Get.to(() => const CreditCardReportPage(origin: "summary"));
  }

  onCreditCardInRefundPendingClick() {
    Get.delete<CreditCardRefundController>();
    Get.to(() => const CreditCardRefundPage(origin: "summary"));
  }

  //bottom section

  onAepsInProgressClick() {
    Get.delete<AepsMatmReportController>(tag: AppTag.aepsReportControllerTag);
    Get.to(() => const AepsMatmReportPage(
        controllerTag: AppTag.aepsReportControllerTag, origin: "summary"));
  }

  onAadhaarPayInProgressClick() {
    Get.delete<AepsMatmReportController>(tag: AppTag.aadhaarPayReportControllerTag);
    Get.to(() => const AepsMatmReportPage(
        controllerTag: AppTag.aadhaarPayReportControllerTag, origin: "summary"));
  }

  onPayoutInProgressClick() {
    Get.delete<MoneyReportController>(tag: AppTag.payoutReportControllerTag);
    Get.to(() => const MoneyReportPage(
        controllerTag: AppTag.payoutReportControllerTag, origin: "summary"));
  }
}
