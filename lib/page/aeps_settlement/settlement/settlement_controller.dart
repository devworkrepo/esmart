import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/model/aeps/settlement/balance.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../data/repo/aeps_repo.dart';
import '../../../model/aeps/settlement/bank.dart';

class AepsSettlementController extends GetxController with TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  AepsSettlementType actionType = Get.arguments["aeps_settlement_type"];
  AepsSettlementBank? settlementBank = Get.arguments["bank_account"];

  var amountController = TextEditingController();
  var remarkController = TextEditingController();
  var bankAccountController = TextEditingController();

  var balanceResponseObs = Resource.onInit(data: AepsBalance()).obs;
  var bankResponseObs = Resource.onInit(data: BankListResponse()).obs;

  var formSpayAccount = GlobalKey<FormState>();
  var formBankAccount = GlobalKey<FormState>();
  AepsBalance? aepsBalance;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      bankAccountController.text = settlementBank?.accountName ?? "";
      _fetchBalance();
    });
  }

  _fetchBalance() async {
    try {
      balanceResponseObs.value = Resource.onInit();
      var response = await repo.fetchAepsBalance();
      if (response.code == 1) {

        aepsBalance = response;
        balanceResponseObs.value = Resource.onSuccess(response);
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong")
            .then((value) => Get.back());
      }
    } catch (e) {
      StatusDialog.failure(title: "Something went wrong")
          .then((value) => Get.back());
    }

  }


  @override
  void dispose() {
    amountController.dispose();
    remarkController.dispose();
    super.dispose();
  }


  onSpayAccountSettlement() async {
    if (!formSpayAccount.currentState!.validate()) return;
    Get.dialog(AmountConfirmDialogWidget(
      onConfirm: () {
        _transfer({
          "transaction_no": aepsBalance!.transaction_no.toString(),
          "amount": amountWithoutRupeeSymbol(amountController),
          "remark": (remarkController.text.isEmpty) ? "Transaction" : remarkController.text,
        });
      },
      amount: amountController.text,
    ));
  }

  _transfer(Map<String, String> param) async {

    try {
      StatusDialog.transaction();

      var response = (actionType == AepsSettlementType.spayAccount)
          ? await repo.spayAccountSettlement(param)
          : await repo.bankAccountSettlement(param);
      Get.back();
      if (response.code == 1) {

        var mCode = ReportHelperWidget.getStatusId(response.trans_status);
        if(mCode == 1){
          StatusDialog.success(title: response.trans_response ?? "Success")
              .then((value) => Get.back());
        }
        else if(mCode == 2){
          StatusDialog.failure(title: response.trans_response ?? "Failure")
              .then((value) => Get.back());
        }
        else {
          StatusDialog.pending(title: response.trans_response ?? "Pending")
              .then((value) => Get.back());
        }



      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onBankSettlement() async {
    if (!formBankAccount.currentState!.validate()) return;
    Get.dialog(AmountConfirmDialogWidget(
      onConfirm: () {
        _transfer({
          "transaction_no": aepsBalance!.transaction_no.toString(),
          "amount": amountWithoutRupeeSymbol(amountController),
          "remark": (remarkController.text.isEmpty) ? "Transaction" : remarkController.text,
          "acc_id": settlementBank?.accountId ?? "",
        });
      },
      amount: amountController.text,
    ));
  }
}

enum AepsSettlementType { spayAccount, bankAccount }
