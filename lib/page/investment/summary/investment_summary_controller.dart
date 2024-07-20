import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/investment_statement.dart';
import 'package:esmartbazaar/model/investment/investment_summary.dart';
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


class InvestmentSummaryController extends GetxController {

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  var responseObs = Resource.onInit(data: InvestmentSummaryResponse()).obs;


  AppPreference appPreference = Get.find();

  @override
  onInit(){
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchSummary();
    });
  }


  fetchSummary() async {
    ObsResponseHandler<InvestmentSummaryResponse>(
        obs: responseObs,
        apiCall: repo.fetchSummary());
  }


}
