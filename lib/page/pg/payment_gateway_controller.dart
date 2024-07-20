import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/money_request_repo.dart';
import 'package:esmartbazaar/data/repo_impl/money_request_impl.dart';
import 'package:esmartbazaar/model/money_request/pg_charge.dart';
import 'package:esmartbazaar/model/money_request/pg_payment_mode.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentGatewayController extends GetxController
    with TransactionHelperMixin {
  final MoneyRequestRepo repo = Get.find<MoneyRequestImpl>();
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  late WebViewController webViewController;

  var isWebViewMode = false.obs;

  String pgUrl = "";

  PgPaymentMode? paymentMode;
  List<PgPaymentMode>? paymentModeList;
  String transactionNumber = "";
  var pgChargeObs = PgChargeResponse().obs;

  Timer? _debounce;

  var paymentModeResponseObs =
      Resource.onInit(data: PgPaymentModeResponse()).obs;

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchPaymentModeList();
    });
  }

  _fetchPaymentModeList() async {
    ObsResponseHandler<PgPaymentModeResponse>(
        obs: paymentModeResponseObs,
        apiCall: repo.fetchPgPaymentList({}),
        result: (value) {
          paymentModeList = value.chglist;
        });
  }

  onSubmit() async {
    if (!formKey.currentState!.validate()) return;
    if (!validateCharge()) {
      StatusDialog.alert(title: "Charge not fetched! go back and try again");
      return;
    }

    StatusDialog.progress(title: "Initiating Payment");
    try{
      final result = await repo.initiatePaymentGateway({
        "channel_name" : paymentMode!.channel_name ?? "",
        "mode_name" : paymentMode!.mode_name ?? "",
        "mode_code" : paymentMode!.mode_code ?? "",
        "transaction_no" : pgChargeObs.value.transaction_no ?? "",
        "remark" : remarkController.text,
        "amount" : amountWithoutRupeeSymbol(amountController),
        "charges" : pgChargeObs.value.charges ?? "",
      });
      Get.back();
      if(result.code == 1){
        pgUrl = result.redirect_url ?? "";
        isWebViewMode.value = true;
      }
      else{
        StatusDialog.alert(title: result.message.toString());
      }

    }catch(e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  bool validateCharge() {
    if (pgChargeObs.value.charges == null ||
        pgChargeObs.value.charges == "" ||
        pgChargeObs.value.charges == "0") {
      return false;
    } else {
      return true;
    }
  }

  onAmountChange(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchCharge();
    });
  }

  void onPaymentModeChange(String value) {
    paymentMode = getPaymentModeFromString(value);
    _fetchCharge();
  }

  _fetchCharge() async {
    pgChargeObs.value = PgChargeResponse();
    final amount = amountWithoutRupeeSymbol(amountController);

    if (amount.isEmpty || amount == "0") return;
    if (paymentMode == null) return;

    try {
      StatusDialog.progress(title: "Fetching charge");
      final result = await repo.fetchPgCharge({
        "mode_name": paymentMode?.mode_name.toString(),
        "mode_code": paymentMode?.mode_code.toString(),
        "amount": amountWithoutRupeeSymbol(amountController),
      });
      pgChargeObs.value = result;
      Get.back();

      if (result.code == 1) {
        transactionNumber = result.transaction_no.toString();
      } else {
        StatusDialog.failure(title: result.message.toString());
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  PgPaymentMode? getPaymentModeFromString(String value) {
    return paymentModeList
        ?.where((element) => element.mode_name == value)
        .first;
  }

  List<String> getPaymentListAsString(List<PgPaymentMode>? list) {
    if (list == null) return [];
    return list.map((e) => e.mode_name.toString()).toList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    amountController.removeListener(() {});
    super.dispose();
  }
}
