import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/response/wallet_load/wallet_load_txn_response_page.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/security/encription.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/wallet_repo.dart';
import 'package:esmartbazaar/data/repo_impl/wallet_repo_impl.dart';
import 'package:esmartbazaar/model/wallet/wallet_fav.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

class WalletTransferController extends GetxController with TransactionHelperMixin ,LocationHelperMixin{
  WalletSearchResponse data = Get.arguments;
  WalletRepo repo = Get.find<WalletRepoImpl>();

  AppPreference appPreference = Get.find();

  var amountController = TextEditingController();
  var remarkController = TextEditingController();
  var mpinController = TextEditingController();
  var isFavouriteChecked = true.obs;
  var formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
    });

  }

  onProceed() async {
    if (!formKey.currentState!.validate()) return;
    if (position == null) {
      await validateLocation();
      return;
    }
    Get.dialog(AmountConfirmDialogWidget(onConfirm: (){
      _transfer();
    },amount: amountController.text,));

  }

  _transfer() async {
    try {
      StatusDialog.transaction();
      var response = await repo.walletTransfer({
        "transaction_no" : data.transactionNumber!,
        "agentid" : data.agentId!,
        "amount" : amountWithoutRupeeSymbol(amountController),
        "remark" : (remarkController.text.isEmpty) ? "Transaction" : remarkController.text,
        "mpin" : Encryption.encryptMPIN(mpinController.text),
        "isfav" : isFavouriteChecked.value.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      });

      Get.back();

      if(response.code == 1){
        response.amount = amountWithoutRupeeSymbol(amountController);
        response.outletName = data.outletName;
        response.agentName = data.agentName;
        Get.to(()=>WalletLoadTxnResponsePage(),arguments: {
          "response" : response
        });
      }
      else {
        StatusDialog.failure(title:  response.message);
      }

    } catch (e) {
      appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}

