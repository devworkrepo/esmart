import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/recharge_repo.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/recharge/recharge.dart';
import 'package:esmartbazaar/model/recharge/response.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

import '../../../util/security/encription.dart';
import '../../response/recharge/recharge_txn_response_page.dart';

class RechargeController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  Map<String, dynamic> argument = Get.arguments;

  AppPreference appPreference = Get.find();

  late Provider provider;
  late String providerImage;
  late String providerName;
  late ProviderType providerType;
  late String transactionNumber;

  //form controllers
  var rechargeFormKey = GlobalKey<FormState>();
  var customerIdController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();


  String amount = "";
  String number = "";


  @override
  void onInit() {
    super.onInit();

    provider = argument["provider"];
    providerImage = argument["provider_image"];
    providerName = argument["provider_name"];
    providerType = argument["provider_type"];
    transactionNumber = argument["transactionNumber"];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
    });
  }



  onProceed() async {
    var isValidate = rechargeFormKey.currentState!.validate();
    if (!isValidate) return;

    if (position == null) {
      await validateLocation();
      return;
    }

    Get.dialog(
        AmountConfirmDialogWidget(
            amount: amountController.text.toString(),
            detailWidget: [
              ListTitleValue(
                  title: "Number", value: customerIdController.text.toString()),
              ListTitleValue(
                  title: "Mobile", value: mobileController.text.toString()),
              ListTitleValue(title: "Provider", value: provider.name),
            ],
            onConfirm: () {
              _makeMobileRecharge();
            }),
        barrierDismissible: false);
  }

  _makeMobileRecharge() async {
    StatusDialog.transaction();
    try {
      cancelToken = CancelToken();

      RechargeResponse response = (providerType == ProviderType.dth)
          ? await repo.makeDthRecharge(_transactionDTHParam(), cancelToken)
          : (providerType == ProviderType.prepaid)
              ? await repo.makeMobilePrepaidRecharge(
                  _transactionRechargeParam(), cancelToken)
              : await repo.makeMobilePostpaidRecharge(
          _transactionRechargeParam(), cancelToken);

      Get.back();

      if (response.code == 1) {
        Get.to(RechargeTxnResponsePage(),
            arguments: {"response": response, "type": providerType});
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(
         ExceptionPage(
          error: e,
          data: {
            "param": (providerType == ProviderType.dth) ? _transactionDTHParam() : _transactionRechargeParam(),
            "transaction_type": "Recharge : ${provider.name.toString()}"
          },
        ),
      );
    }
  }

  _transactionRechargeParam() => {
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "transaction_no": transactionNumber,
        "operatorid": provider.id.toString(),
        "operatorname": provider.name.toString(),
        "mobileno": customerIdController.text.toString(),
        "amount": amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      };

  _transactionDTHParam() => {
    "mpin": Encryption.encryptMPIN(mpinController.text),
    "transaction_no": transactionNumber,
    "operatorid": provider.id.toString(),
    "operatorname": provider.name.toString(),
    "customerid": customerIdController.text.toString(),
    "mobileno": mobileController.text.toString(),
    "amount": amountWithoutRupeeSymbol(amountController),
    "latitude": position!.latitude.toString(),
    "longitude": position!.longitude.toString(),
  };

  String getNumberLabel() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid) {
      return "Mobile Number";
    } else if (providerType == ProviderType.dth) {
      return "Customer Id";
    }
    return "";
  }

  String getNumberHintText() {
    if (providerType == ProviderType.prepaid) {
      return "Enter 10 digit prepaid mobile number";
    }
    if (providerType == ProviderType.postpaid) {
      return "Enter 10 digit postpaid mobile number";
    } else if (providerType == ProviderType.dth) {
      return "Enter 6 - 14 digits Customer Id";
    }
    return "";
  }

  numberValidation(String? value) {
    if (providerType == ProviderType.postpaid ||
        providerType == ProviderType.prepaid) {
      if (value!.length == 10) {
        return null;
      } else {
        return "Enter 10 digits mobile number";
      }
    } else if (providerType == ProviderType.dth) {
      if (value!.length > 5 && value.length < 15) {
        return null;
      } else {
        return "Enter valid 6 - 14 digits Customer Id";
      }
    } else {
      return "Provider Type not valid";
    }
  }

  getMaxLength() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid) {
      return 10;
    } else if (providerType == ProviderType.dth) {
      return 14;
    } else {
      return 20;
    }
  }

  @override
  void dispose() {
    customerIdController.dispose();
    mobileController.dispose();
    amountController.dispose();
    mpinController.dispose();
    if (cancelToken != null) {
      if (!(cancelToken?.isCancelled ?? false)) {
        cancelToken
            ?.cancel("Transaction was initiate but didn't catch response");
      }
    }
    super.dispose();
  }
}
