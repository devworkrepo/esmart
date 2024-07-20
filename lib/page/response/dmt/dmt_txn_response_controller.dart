import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/util/app_util.dart';

class DmtTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  DmtTransactionResponse dmtTransactionResponse = Get.arguments["response"];
  String totalAmount = Get.arguments["amount"];
  DmtType? dmtType = Get.arguments["dmtType"];
  bool isUpi = Get.arguments["isUpi"] ?? false;

  @override
  void onInit() {
    super.onInit();
  }

  String getGlobalStatus() {
    if (dmtTransactionResponse.transactionList == null) {
      return "InProgress";
    }

    AppUtil.logger("Hello dev");

    var success = 0;
    var failure = 0;
    var pending = 0;
    var refundPending = 0;
    var inProgress = 0;
    dmtTransactionResponse.transactionList?.forEach((element) {
      if (element.transactionStatus.toString().toLowerCase() == "success" ||
          element.transactionStatus.toString().toLowerCase() == "initiated") {
        success += 1;
      } else if (element.transactionStatus.toString().toLowerCase() ==
              "failed" ||
          element.transactionStatus.toString().toLowerCase() == "failure") {
        failure += 1;
      } else if (element.transactionStatus.toString().toLowerCase() ==
          "pending") {
        pending += 1;
      } else if (element.transactionStatus.toString().toLowerCase() ==
          "refund pending") {
        refundPending += 1;
      } else if (element.transactionStatus.toString().toLowerCase() ==
          "inprogress") {
        inProgress += 1;
      }
    });

    if (success == dmtTransactionResponse.transactionList!.length) {
      return "Success";
    } else if (failure == dmtTransactionResponse.transactionList!.length) {
      return "Failure";
    } else if (pending == dmtTransactionResponse.transactionList!.length) {
      return "Pending";
    } else if (inProgress == dmtTransactionResponse.transactionList!.length) {
      return "InProgress";
    } else if (inProgress == dmtTransactionResponse.transactionList!.length) {
      return "Refund Pending";
    }
    else if (refundPending == dmtTransactionResponse.transactionList!.length) {
      return "Refund Pending";
    }
    else if (success > 0 &&
        success < dmtTransactionResponse.transactionList!.length) {
      return "Success";
    } else {
      return "Successful";
    }
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: totalAmount,
        type: getSubTitle());
  }

  getSubTitle() {


    if(dmtType == null && isUpi){
      return "Upi Transaction";
    }

    switch (dmtType) {
      case DmtType.instantPay:
        return "Money Transfer";
      case DmtType.payout:
        return "Payout Transfer";
      default:
        return "Transaction ";
    }
  }
}