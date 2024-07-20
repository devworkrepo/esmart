import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/recharge/bill_payment.dart';
import 'package:esmartbazaar/model/recharge/recharge.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/recharge/provider/provider_controller.dart';
import 'package:esmartbazaar/util/app_util.dart';

class BillPaymentTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  BillPaymentResponse response = Get.arguments["response"];
  ProviderType? provider = Get.arguments["type"];
  bool isPartBill = Get.arguments["isPartBill"] ?? false;

  String getSvgImage(){
    if(provider == ProviderType.electricity){
      return "assets/svg/electricity.svg";
    }
    if(provider == ProviderType.water){
      return "assets/svg/water.svg";
    }
    if(provider == ProviderType.gas){
      return "assets/svg/gas.svg";
    }
    if(provider == ProviderType.landline){
      return "assets/svg/landline.svg";
    }
    else {
      return "assets/svg/electricity.svg";
    }
  }

  String getPngImage(){
    return "assets/image/lic.png";
  }


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: (provider == null) ? "Payment " : getProviderInfo (provider!)?.name ?? "Payment ");
  }
}