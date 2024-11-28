import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
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
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';

import '../../../util/security/encription.dart';
import '../../fund/component/bond_dialog.dart';

class DmtTransactionController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AppPreference appPreference = Get.find();

  DmtRepo repo = Get.find<DmtRepoImpl>();

  SenderInfo sender = Get.arguments["sender"];
  Beneficiary beneficiary = Get.arguments["beneficiary"];

  DmtType dmtType = Get.arguments["dmtType"];

  var transactionChargeWidgetVisibilityObs = false.obs;

  var calculateChargeResponseObs =
      Resource.onInit(data: CalculateChargeResponse()).obs;
  late CalculateChargeResponse calculateChargeResponse;

  var formKey = GlobalKey<FormState>();
  var mpinController = TextEditingController();
  var remarkController = TextEditingController();
  var otpController = TextEditingController();

  DmtTransferType transferType = Get.arguments["type"];
  String amount = Get.arguments["amount"];
  String isView = Get.arguments["isView"];

  var otpcode = "";

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
    if (!(appPreference.user.isPayoutBond ?? false) &&
        dmtType == DmtType.payout) {
      _fetchBondInfo();
    } else {
      _confirmDialog();
    }
  }

  _fetchBondInfo() async {
    StatusDialog.progress(title: "Fetching Payout Bond");
    try {
      var response = await repo.fetchPayoutBond();
      Get.back();
      if (response.code == 1) {
        Get.dialog(BondDialog(
          data: response.content!,
          onAccept: () {
            _confirmDialog();
          },
          onReject: () {
            showFailureSnackbar(
                title: "Payout Bond Rejected",
                message:
                    "To proceed transaction need to accept payout bond. Without it transaction can't be proceed further.");
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _confirmDialog() {
    var widgetList = <ListTitleValue>[];

    widgetList = [
      ListTitleValue(title: "Name", value: beneficiary.name ?? ""),
      ListTitleValue(title: "A/C No.", value: beneficiary.accountNumber ?? ""),
      ListTitleValue(title: "Bank", value: beneficiary.bankName ?? ""),
      ListTitleValue(title: "IFSc", value: beneficiary.ifscCode ?? ""),
    ];

    Get.dialog(AmountConfirmDialogWidget(
        amount: amount,
        detailWidget: widgetList,
        onConfirm: () {
          _dmtTransfer();
        }));
  }

  _dmtTransfer() async {
    var value = checkBalance(appPreference.user.availableBalance, amount);
    if (!value) return;
    if (position == null) {
      await validateLocation();
      return;
    }

    if(dmtType == DmtType.dmt2 && otpcode.isEmpty){
      StatusDialog.alert(title: "Please send otp, otp code is not fetched yet");
      return;
    }

    try {
      cancelToken = CancelToken();
      StatusDialog.transaction();

      DmtTransactionResponse response;

      switch (dmtType) {
        case DmtType.instantPay:
          if ((sender.isKycVerified ?? false)) {
            response =
            await repo.kycTransaction(_transactionParam(), cancelToken);
          } else {
            response =
            await repo.nonKycTransaction(_transactionParam(), cancelToken);
          }
          break;
        case DmtType.dmt2:
          response = await repo.dmt2Transaction(_transactionParam(), cancelToken);
          break;
        case DmtType.payout:
          response =
              await repo.payoutTransaction(_transactionParam(), cancelToken);
          break;
      }

      Get.back();

      if (response.code == 0) {
        StatusDialog.failure(title: response.message);
      } else {
        Get.to(() => DmtTxnResponsePage(), arguments: {
          "response": response,
          "amount": amount,
          "dmtType": dmtType
        });
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(
            error: e,
            data: {
              "param": _transactionParam(),
              "transaction_type": "DMT : ${dmtType.name.toString()}"
            },

          ));
    }
  }

  _transactionParam() {
    final param = {
      "beneid": beneficiary.id ?? "",
    "transfer_amt": amount,
    "mpin": Encryption.encryptMPIN(mpinController.text),
    "remark": (remarkController.text.isEmpty)
    ? "Transaction"
        : remarkController.text,
    "calcid": calculateChargeResponse.calcId.toString(),
    "trans_type": (transferType == DmtTransferType.imps) ? "IMPS" : "NEFT",
    "latitude": position!.latitude.toString(),
    "longitude": position!.longitude.toString(),
  };
    
    param.addIf(dmtType == DmtType.dmt2, "otp", otpController.text);
    param.addIf(dmtType == DmtType.dmt2, "otpcode", otpcode);

    return param;
    
  }

  _calculateTransactionCharge() async {
    try {
      var param = <String, String>{
        "remitter_mobile": sender.senderNumber.toString(),
        "beneid": beneficiary.id.toString(),
        "isview": isView,
        "trans_type": (transferType == DmtTransferType.imps) ? "IMPS" : "NEFT",
        "amount": amount,
        "sessionkey": appPreference.sessionKey,
        "dvckey": await AppUtil.getDeviceID()
      };

      calculateChargeResponseObs.value = const Resource.onInit();
      CalculateChargeResponse response;

      var isDmtKyc = false;
      if(sender.isKycVerified == true){
        if(transferType == DmtTransferType.imps){
          isDmtKyc = sender.iskycimps ?? false;
        }
        else if(transferType == DmtTransferType.neft){
          isDmtKyc = sender.iskycneft ?? false;
        }
      }

      if(dmtType == DmtType.dmt2){
        response = await repo.calculateKycCharge2(param);
      }
     else if (dmtType == DmtType.instantPay) {
        if (isDmtKyc) {
          response = await repo.calculateKycCharge(param);
        } else {
          response = await repo.calculateNonKycCharge(param);
        }
      } else {
        response = await repo.calculatePayoutCharge(param);
      }

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

  requestOtp()  async {

    StatusDialog.progress();
    try {
      var response = await repo.sendDmt2TransactionOtp({
        "mobileno": sender.senderNumber ?? "",
      });

      Get.back();
      if (response.code == 1) {
        otpcode = response.otpcode ?? "";
        showSuccessSnackbar(
            title: "Transaction OTP", message: response.message);
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }

  }
}
