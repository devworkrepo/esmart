import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/inventment_balance.dart';
import 'package:esmartbazaar/model/investment/inventment_calc.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class CreateInvestmentController extends GetxController with TransactionHelperMixin{
  TextEditingController amountController = TextEditingController();
  TextEditingController tenureController = TextEditingController();

  late InvestmentBalanceResponse balance;
  var tenureType = "Days";
  var isAgree = false;
  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  var responseObs = Resource.onInit(data: InvestmentBalanceResponse()).obs;
  AppPreference appPreference = Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchInvestmentBalance();
    });
  }

  fetchInvestmentBalance() async{

    ObsResponseHandler(obs: responseObs, apiCall: repo.fetchInvestmentBalance());

  }

  onSubmit() async{
    var strAmount = amountWithoutRupeeSymbol(amountController);
    if(strAmount.isEmpty) strAmount = "0";

    var strTenure = tenureController.text.toString();
    if(strTenure.isEmpty) strTenure = "0";

    var amount = int.parse(strAmount);
    var tenure = int.parse(strTenure);

    if(amount < 1){
      StatusDialog.alert(title: "Enter valid amount!");
      return;
    }
    if (amount.toDouble() >
        double.parse(appPreference.user.availableBalance!)) {
      StatusDialog.alert(
          title: "Insufficient balance, your available balance is : " +
              appPreference.user.availableBalance!.toString());
      return;
    }
    if(tenure < 1){
      StatusDialog.alert(title: "Enter valid tenure!");
      return;
    }
    if(!isAgree){
      StatusDialog.alert(title: "Need to agree kyc detail with this investment!");
      return;
    }

    _fetchCalc(amount.toString(),tenure.toString());

  }

  _fetchCalc(String amount,String tenure) async{
    StatusDialog.progress(title: "Fetching Detail...");
    InvestmentCalcResponse response = await repo.fetchInvestmentCalc({
      "investamt" : amount,
      "durationtype" : tenureType,
      "durationvalue" : tenure,

    });
    Get.back();
    if(response.code ==1){
      Get.toNamed(AppRoute.reviewInvestmentPage,arguments: {
        "balance" : balance,
        "calc" : response,
        "amount" : amount.toString(),
        "tenureDuration" : tenure,
        "tenureType" : tenureType,
      });
    }
    else {
      StatusDialog.alert(title: response.message);
    }


  }

  void checkPanDetail() async{

    StatusDialog.progress(title: "Checking Pan Detail");
    CommonResponse response = await repo.checkPanDetail();
    Get.back();
    if(response.code ==1){
      Get.toNamed(AppRoute.investmentPanPage)?.then(
              (value) => fetchInvestmentBalance());
    }
    else{
      StatusDialog.alert(title: response.message);
    }

  }
}