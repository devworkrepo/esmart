import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/recharge_repo.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/model/recharge/extram_param.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/recharge/response.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/recharge/provider/provider_controller.dart';
import 'package:esmartbazaar/page/response/bill_payment/bill_payment_txn_response_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';

import '../../../util/security/encription.dart';

class BillPaymentController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  Map<String, dynamic> argument = Get.arguments;

  AppPreference appPreference = Get.find();

  var actionType = BillPaymentActionType.fetchBill.obs;

  late Provider provider;
  late String providerImage;
  late String providerName;
  late ProviderType providerType;

  var isPartBillPayment = false;

  //form controllers
  var billFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var fieldOneController = TextEditingController();
  var fieldTwoController = TextEditingController();
  var fieldThreeController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();

  var extraParamResponseObs =
      Resource.onInit(data: BillExtraParamResponse()).obs;
  late BillExtraParamResponse extraParamResponse;
  late BillInfoResponse billInfoResponse;

  var strDueDate = "";
  var billContext = "";

  @override
  void onInit() {
    super.onInit();

    provider = argument["provider"];
    providerImage = argument["provider_image"];
    providerName = argument["provider_name"];
    providerType = argument["provider_type"];
    isPartBillPayment = argument["is_part_bill"] ?? false;

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchExtraParam();
    });
  }

  _fetchExtraParam() async {
    extraParamResponseObs.value = const Resource.onInit();

    try {
      var response = await repo.fetchExtraParam({
        "operatorid": provider.id,
        "cattype": getProviderInfo(providerType)?.requestParam ?? ""
      });
      if (response.code == 1) {
        if (providerType == ProviderType.insurance) {
          response.field1 = "Policy Number";
          response.field2 = "Date of Birth";
          response.field3 = "Email ID";
        }
        extraParamResponse = response;
        extraParamResponseObs.value = Resource.onSuccess(response);
      } else {
        throw "Extra param status was not success! please contact with admin";
      }
    } catch (e) {
      extraParamResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onProceed() async {
    if (!_validateForFetchBill()) return;

    if (position == null) {
      await validateLocation();
      return;
    }

    if (actionType.value == BillPaymentActionType.fetchBill) {
      _fetchBillInfo();
    } else {
      _confirmBillPayDialog();
    }
  }

  bool _validateForFetchBill() {
    var isValidate = billFormKey.currentState!.validate();
    if (!isValidate) return false;
    return true;
  }

  _confirmBillPayDialog() {
    var value = checkBalance(
        appPreference.user.availableBalance, amountController.text.trim());
    if (!value) return;

    Get.dialog(
        AmountConfirmDialogWidget(
            isDecimal: true,
            amount: amountController.text.toString(),
            detailWidget: [
              ListTitleValue(
                  title: "Number", value: fieldOneController.text.toString()),
              ListTitleValue(title: "Provider", value: provider.name),
            ],
            onConfirm: () {
              _makeBillPayment();
            }),
        barrierDismissible: false);
  }

  _paymentParam() => <String, String>{
        "transaction_no": billInfoResponse.transactionNumber ?? "",
        "cattype": getProviderInfo(providerType)?.requestParam ?? "",
        "operatorid": provider.id,
        "operatorcode": provider.operatorCode,
        "operatorname": provider.name,
        "customername": billInfoResponse.name ?? "",
        "mobileno": mobileNumberController.text,
        "amount": amountController.text,
        "field1": fieldOneController.text,
        "field2": fieldTwoController.text,
        "field3": fieldThreeController.text,
        "dob": fieldTwoController.text,
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      };

  _makeBillPayment() async {
    var validBalance = checkBalance(
        appPreference.user.availableBalance, amountController.text);
    if (!validBalance) return;

    StatusDialog.transaction();
    try {
      cancelToken = CancelToken();

      var response = (isPartBillPayment)
          ? await repo.makePartBillPayment(_paymentParam(), cancelToken)
          : await repo.makeOfflineBillPayment(_paymentParam(), cancelToken);
      Get.back();
      if (response.code == 1) {
        Get.to(() => BillPaymentTxnResponsePage(), arguments: {
          "response": response,
          "type": providerType,
          "isPartBill": isPartBillPayment
        });
      } else {
        StatusDialog.failure(title: response.message ?? "message not found");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.to(() => ExceptionPage(
            error: e,
            data: {
              "param": _paymentParam(),
              "transaction_type": "Bill Payment : ${provider.name.toString()}"
            },
          ));
    }
  }

  _fetchBillInfo() async {
    try {
      StatusDialog.progress(title: "Fetching");

      BillInfoResponse response = await repo.fetchBillInfo({
        "field1": fieldOneController.text,
        "field2": fieldTwoController.text,
        "field3": fieldThreeController.text,
        "dob": fieldTwoController.text,
        "mobileno": mobileNumberController.text,
        "operatorid": provider.id.toString(),
        "transaction_no": extraParamResponse.transactionNumber ?? "",
        "cattype": getProviderInfo(providerType)?.requestParam ?? "",
      });
      Get.back();

      if (response.code == 1) {
        Get.snackbar("Bill Info", response.message ?? "Something went wrong!",
            backgroundColor: Colors.green, colorText: Colors.white);
        billInfoResponse = response;
        actionType.value = BillPaymentActionType.payBill;
        amountController.text = response.amount!;
      } else {
        Get.snackbar("Bill Info", response.message ?? "Something went wrong!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  getButtonText() {
    return (actionType.value == BillPaymentActionType.fetchBill)
        ? "Fetch Bill Info"
        : "Pay Bill";
  }

  isFieldEnable() {
    return actionType.value == BillPaymentActionType.fetchBill;
  }

  bool isAmountEnable() {
    if (isPartBillPayment) {
      return true;
    } else {
      return (billInfoResponse.isPart ?? false);
    }
  }

  @override
  void dispose() {
    fieldOneController.dispose();
    amountController.dispose();
    mobileNumberController.dispose();
    fieldTwoController.dispose();
    fieldThreeController.dispose();
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

enum BillPaymentActionType { fetchBill, payBill }
