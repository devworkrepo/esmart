import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/aeps/aeps_transaction.dart';
import 'package:esmartbazaar/page/aeps/aeps_tramo/aeps_page.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../aeps/transaction_type.dart';

class AepsTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  AepsTransactionResponse response = Get.arguments["response"];
  AepsTransactionType aepsTransactionType = Get.arguments["aeps_type"];
  bool isAadhaarPay = Get.arguments["isAadhaarPay"];

  String getTitle() {
    if (isAadhaarPay) {
      return "Aadhaar Pay";
    } else {
      return "AEPS";
    }
  }

  String getSubTitle() {
    if (isAadhaarPay) {
      return "Cash Withdrawal";
    } else {
      switch (aepsTransactionType) {
        case AepsTransactionType.cashWithdrawal:
          return "Cash Withdrawal";
        case AepsTransactionType.balanceEnquiry:
          return "Balance Enquiry";
      }
    }
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: getTitle());
  }
}
