import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/model/matm/matm_request_response.dart';
import 'package:esmartbazaar/page/aeps/aeps_tramo/aeps_page.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../matm_tramo/matm_page.dart';

class MatmTramoTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  MatmResult response = Get.arguments["response"];
  MatmTramoTransactionType type = Get.arguments["txnType"];



  String getTxnType(){
    if(type == MatmTramoTransactionType.cashWithdrawal){
      return "Cash Withdrawal";
    }
    else {
      return "Balance Enquiry";
    }
  }


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.transAmount.toString(),
        type: "Micro Atm");
  }
}
