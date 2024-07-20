import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/inventment_balance.dart';
import 'package:esmartbazaar/model/investment/inventment_calc.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class ReviewInvestmentController extends GetxController {
  TextEditingController pinController = TextEditingController();

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  InvestmentBalanceResponse balance = Get.arguments["balance"]!;
  InvestmentCalcResponse calc = Get.arguments["calc"]!;
  String tenureType = Get.arguments["tenureType"]!;
  String tenureDuration = Get.arguments["tenureDuration"]!;
  String amount = Get.arguments["amount"]!;

  @override
  void onInit() {
    super.onInit();
  }

  void onSubmit() async {
    var mpin = pinController.text.toString();
    if (mpin.length > 3 && mpin.length < 7) {
      StatusDialog.progress(title: "Proceeding...");
      CommonResponse response = await repo.createInvestment({
        "investamt": amount,
        "durationtype": tenureType,
        "durationvalue": tenureDuration,
        "trans_no" : balance.trans_no.toString()
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.transResponse.toString())
            .then((value) => Get.offAllNamed(AppRoute.investmentListPage,arguments: {
              "home" : true
        }));
      } else {
        StatusDialog.alert(title: response.message);
      }
    } else {
      StatusDialog.alert(title: "Enter valid mpin");
    }
  }
}
