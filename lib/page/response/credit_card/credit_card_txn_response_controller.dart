import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/recharge/credit_card.dart';
import 'package:esmartbazaar/util/app_util.dart';

class CreditCardTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  CreditCardPaymentResponse response = Get.arguments["response"];


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: "Credit Card");
  }
}
