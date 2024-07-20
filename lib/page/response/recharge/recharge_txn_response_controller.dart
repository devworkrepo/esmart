import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/recharge/recharge.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/util/app_util.dart';

class RechargeTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  RechargeResponse response = Get.arguments["response"];
  ProviderType provider = Get.arguments["type"];

  String getSvgImage(){
    if(provider == ProviderType.dth){
      return "assets/svg/dth.svg";
    }
    else {
      return "assets/svg/mobile.svg";
    }
  }

  String getTitle(){
    if(provider == ProviderType.dth){
      return "Dth Recharge";
    }
   else if(provider == ProviderType.prepaid){
      return "Prepaid Recharge";
    }
    else if(provider == ProviderType.postpaid){
      return "Postpaid Recharge";
    }

    else if(provider == ProviderType.ott){
      return "OTT Subscription";
    }

    else {
      return "Recharge";
    }
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: getTitle());
  }
}