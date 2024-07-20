import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/model/aeps/settlement/aeps_calc.dart';
import 'package:esmartbazaar/model/aeps/settlement/balance.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../data/repo/aeps_repo.dart';
import '../../../model/aeps/settlement/bank.dart';

class AepsBankTransferController extends GetxController
    with TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  var formBankAccount = GlobalKey<FormState>();
  double aepsBalance = Get.arguments["aeps_balance"];
  AepsSettlementBank bank = Get.arguments["bank_account"];

  AepsSettlementBank? settlementBank = Get.arguments["bank_account"];

  var mpinController = TextEditingController();
  var remarkController = TextEditingController();
  var bankAccountController = TextEditingController();

  var calcObs = Resource.onInit(data: AepsSettlementCalcResponse()).obs;
  late AepsSettlementCalcResponse calcResponse;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      bankAccountController.text = settlementBank?.accountName ?? "";
      _fetchCalc();
    });
  }

  _fetchCalc() async {
    try {
      calcObs.value = const Resource.onInit();

      final param = {"amount": bank.transferAmount.value.toString()};

      var response = await repo.fetchAepsCalc(param);
      if (response.code == 1) {
        calcResponse = response;
        calcObs.value = Resource.onSuccess(response);
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
    mpinController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  _transfer(Map<String, String> param) async {
    try {
      StatusDialog.transaction();

      var response = await repo.bankAccountSettlement(param);
      Get.back();
      if (response.code == 1) {
        var mCode = ReportHelperWidget.getStatusId(response.trans_status);
        var message = (response.trans_response != null &&
                response.trans_response != "")
            ? response.trans_response
            : (response.trans_status != null && response.trans_status != null)
                ? response.trans_status
                : response.status;
        if (mCode == 1) {
          StatusDialog.success(title: message ?? "Success")
              .then((value) => Get.back(result: true));
        } else if (mCode == 2) {
          StatusDialog.failure(title: message ?? "Failure")
              .then((value) => Get.back());
        } else {
          StatusDialog.pending(title: message ?? "Pending")
              .then((value) => Get.back(result: true));
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
          "transaction_no": calcResponse.transaction_no.toString(),
          "amount": bank.transferAmount.value.toString(),
          "remark": (remarkController.text.isEmpty)
              ? "Transaction"
              : remarkController.text,
          "acc_id": settlementBank?.accountId ?? "",
          "mpin": mpinController.text.toString(),
        });
      },
      amount: bank.transferAmount.value.toString(),
    ));
  }
}
