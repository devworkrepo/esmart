import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/recharge_repo.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';

import '../../util/security/encription.dart';
import '../../widget/common.dart';
import '../../widget/dialog/status_dialog.dart';
import '../../util/mixin/transaction_helper_mixin.dart';
import '../exception_page.dart';
import '../response/paytm_wallet/paytm_wallet_txn_response_page.dart';

class PaytmWalletController extends GetxController with TransactionHelperMixin,LocationHelperMixin {
  var mobileController = TextEditingController();
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  RechargeRepo repo = Get.find<RechargeRepoImpl>();
  AppPreference appPreference = Get.find();

  var actionType = PaytmWalletLoadActionType.verify.obs;


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
    });
  }

  verify() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (position == null) {
      await validateLocation();
      return;
    }


    String? transactionNumber = await fetchTransactionNumber();
    if (transactionNumber == null) {
      StatusDialog.failure(title: "Transaction Number is Required");
      return;
    }

    try {
      StatusDialog.progress();
      var response = await repo.verifyPaytmWallet({
        "transaction_no": transactionNumber,
        "mobileno": mobileController.text
      });
      Get.back();
      if (response.code == 1) {
        var statusCode = ReportHelperWidget.getStatusId(response.trans_status);
        if (statusCode == 1) {
          showSuccessSnackbar(
              title: "Paytm Wallet Info",
              message: response.trans_response ?? response.message ?? "");
          actionType.value = PaytmWalletLoadActionType.transaction;
        } else {
          StatusDialog.failure(title: response.trans_response ?? "");
        }
      } else {
        showFailureSnackbar(
            title: "Something went wrong", message: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  Future<String?> fetchTransactionNumber() async {
    try {
      StatusDialog.progress();
      var response = await repo.fetchTransactionNumber();
      Get.back();
      if (response.code == 1) {
        return response.transactionNumber;
      } else {
        showFailureSnackbar(
            title: "Something went wrong", message: response.message);
        return null;
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
      return null;
    }
  }

  withoutVerify() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    actionType.value = PaytmWalletLoadActionType.transaction;
  }

  onProceed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (position == null) {
      await validateLocation();
      return;
    }

    Get.dialog(AmountConfirmDialogWidget(
        amount: amountController.text,
        onConfirm: () {
          _loadPytmWallet();
        }));
  }

  _loadPytmWallet() async {
    try {

      String? transactionNumber = await fetchTransactionNumber();
      if (transactionNumber == null) {
        StatusDialog.failure(title: "Transaction Number is Required");
        return;
      }

      StatusDialog.transaction();
      var response = await repo.paymtWalletLoadTransaction({
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "transaction_no": transactionNumber,
        "mobileno": mobileController.text,
        "amount": amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      });
      Get.back();
      if (response.code == 1) {
        Get.to(() => PaytmWalletTxnResponsePage(),
            arguments: {"response": response});
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}

enum PaytmWalletLoadActionType { verify, transaction }
