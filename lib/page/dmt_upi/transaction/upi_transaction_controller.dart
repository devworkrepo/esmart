import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/calculate_charge.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/response/dmt/dmt_txn_response_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';

import '../../../util/security/encription.dart';

class UpiTransactionController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AppPreference appPreference = Get.find();

  UpiRepo repo = Get.find<UpiRepoImpl>();

  SenderInfo sender = Get.arguments["sender"];
  Beneficiary beneficiary = Get.arguments["beneficiary"];

  var transactionChargeWidgetVisibilityObs = false.obs;

  var calculateChargeResponseObs =
      Resource.onInit(data: CalculateChargeResponse()).obs;
  late CalculateChargeResponse calculateChargeResponse;

  var formKey = GlobalKey<FormState>();
  var mpinController = TextEditingController();
  var remarkController = TextEditingController();

  String amount = Get.arguments["amount"];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
      _calculateTransactionCharge();
    });
  }

  void onProceed() async {
    if (!formKey.currentState!.validate()) return;
    _confirmDialog();

  }

  _confirmDialog() {
    var widgetList = <ListTitleValue>[];

    widgetList = [
      ListTitleValue(title: "Name", value: beneficiary.name ?? ""),
      ListTitleValue(title: "Upi Id", value: beneficiary.accountNumber ?? ""),

    ];

    Get.dialog(AmountConfirmDialogWidget(
        amount: amount,
        detailWidget: widgetList,
        onConfirm: () {
          _upiTransfer();
        }));
  }

  _upiTransfer() async {
    var value = checkBalance(appPreference.user.availableBalance, amount);
    if (!value) return;
    if (position == null) {
      await validateLocation();
      return;
    }

    try {
      cancelToken = CancelToken();
      StatusDialog.transaction();

      DmtTransactionResponse response;

      response = await repo.transaction(_transactionParam(), cancelToken);

      Get.back();

      if (response.code == 0) {
        StatusDialog.failure(title: response.message);
      } else {
        Get.to(() => DmtTxnResponsePage(), arguments: {
          "response": response,
          "amount": amount,
          "dmtType": null,
          "isUpi" : true
        });
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(
            error: e,
            data: {
              "param": _transactionParam(),
              "amount" : amount,
              "transaction_type": "UPI"
            },

          ));
    }
  }

  _transactionParam() => {
        "beneid": beneficiary.id ?? "",
        "transfer_amt": amount,
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "remark": (remarkController.text.isEmpty)
            ? "Transaction"
            : remarkController.text,
        "calcid": calculateChargeResponse.calcId.toString(),
        // "latitude": position!.latitude.toString(),
        // "longitude": position!.longitude.toString(),
      };

  _calculateTransactionCharge() async {
    try {

      var param = <String, String>{
        "remitter_mobile": sender.senderNumber.toString(),
        "beneid": beneficiary.id.toString(),
        "amount": amount,
        "sessionkey": appPreference.sessionKey,
        "dvckey": await AppUtil.getDeviceID()
      };

      calculateChargeResponseObs.value = const Resource.onInit();
      CalculateChargeResponse response;



      response = await repo.calculatePayoutUpiCharge(param);
      calculateChargeResponse = response;

      if (response.code == 1) {
        calculateChargeResponseObs.value = Resource.onSuccess(response);
      } else {
        StatusDialog.failure(title: response.message)
            .then((value) => Get.back());
      }
    } catch (e) {
      calculateChargeResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void setTransactionChargeWidgetVisibility() {
    transactionChargeWidgetVisibilityObs.value =
        !transactionChargeWidgetVisibilityObs.value;
  }

  @override
  void dispose() {
    mpinController.dispose();
    remarkController.dispose();
    if (cancelToken != null) {
      if (!(cancelToken?.isCancelled ?? false)) {
        cancelToken
            ?.cancel("Transaction was initiate but didn't catch response");
      }
    }
    super.dispose();
  }
}
