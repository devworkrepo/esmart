import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/matm/matm_request_response.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/matm_tramo/process/matm_process_page.dart';
import 'package:esmartbazaar/service/location.dart';
import 'package:esmartbazaar/service/native_call.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../model/aeps/aeps_bank.dart';
import '../../route/route_name.dart';
import '../../util/api/resource/resource.dart';
import '../../widget/list_component.dart';
import '../aeps/widget/ekyc_info_widget.dart';
import '../response/matm_tramo/matm_txn_response_page.dart';
import 'matm_page.dart';

class MatmTramoController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  bool _redirectForReQueryPage = false;

  AepsRepo repo = Get.find<AepsRepoImpl>();
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();
  AppPreference appPreference = Get.find();

  var matmFormKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();
  var transactionType = MatmTramoTransactionType.cashWithdrawal.obs;
  String? transactionNumber;
  MatmRequestResponse? requestResponse;
  bool updateToServerCalled = false;

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  @override
  void onInit() {
    super.onInit();
    _fetchBankList();
  }

  void _fetchBankList() async {
    try {
      aepsBankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsBankList();
      if (response.code == 1) {
        aepsBankListResponseObs.value = Resource.onSuccess(response);
        if (!(response.isEKcy ?? false)) {
          showEkcyDialog(
              "E-Kyc is Required.",
              "To do aeps, aadhaar pay and matm transaction E-Kyc is required!",
              AppRoute.aepsEkycPage);
        }
      } else if (response.code == 2) {
        showEkcyDialog(
          "OnBoarding Required",
          response.message ??
              "To do aeps, aadhaar pay and matm transaction"
                  " OnBoarding is required!",
          AppRoute.aepsOnboardingPage,
        );
      } else if (response.code == 3) {
        StatusDialog.pending(
                title: response.message ?? "Pending",
                buttonText: "Bank to Home")
            .then((value) => Get.back());
      } else {
        validateLocation(progress: false);
      }
    } catch (e) {
      aepsBankListResponseObs.value = Resource.onFailure(e);
    }
  }

  void showEkcyDialog(String title, String message, String route) {
    Get.bottomSheet(
        EkycInfoWidget(
            title: title,
            message: message,
            onClick: () {
              Get.back();
              Get.offAndToNamed(route);
            },
            onCancel: () {
              Get.back();
              Get.back();
            }),
        isDismissible: false,
        persistent: false,
        enableDrag: false);
  }

  void onProceed() async {
    var isValidate = matmFormKey.currentState!.validate();
    if (!isValidate) return;

    try {
      await validateLocation(progress: true);
      if (position == null) return;
    } catch (e) {
      return;
    }

    Get.dialog(AmountConfirmDialogWidget(
        amount:
            (transactionType.value == MatmTramoTransactionType.cashWithdrawal)
                ? amountController.text
                : null,
        title: "Matm Transaction ? ",
        detailWidget: [
          ListTitleValue(title: "Mobile No.", value: mobileController.text),
          ListTitleValue(
              title: "Txn Type", value: getTransactionTypeInString()),
        ],
        onConfirm: () {
          _getTransactionNumber();
        }));
  }

  _getTransactionNumber() async {
    try {
      StatusDialog.progress(title: "Initiating Transaction...");
      var response = await homeRepo.getTransactionNumber();
      if (response.code == 1) {
        transactionNumber ??= response.transactionNumber;
        if (requestResponse == null) {
          _initiateTransaction();
        }
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _initiateTransaction() async {
    try {
      requestResponse = await repo.initiateMatm({
        "transaction_no": transactionNumber,
        "cust_mobile": mobileController.text,
        "txntype": getSpayRequestTxnType(),
        "deviceid": await AppUtil.getDeviceID(),
        "amount":
            transactionType.value == MatmTramoTransactionType.balanceEnquiry
                ? "0"
                : amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString()
      });
      Get.back();
      if (requestResponse!.code == 1) {
        Get.focusScope?.unfocus();
        _callMatmNativeMethod();
      } else {
        StatusDialog.failure(
            title: requestResponse!.message ?? "Not available");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _callMatmNativeMethod() async {
    try {
      var params = {
        "merchantUserId": requestResponse?.loginId ?? "",
        "merchantPassword": requestResponse?.loginPin ?? "",
        "superMerchantId": requestResponse?.superMerchantId ?? "",
        "amount": amountWithoutRupeeSymbol(amountController),
        "remark": "transaction",
        "mobileNumber": mobileController.text,
        "txnId": "tr${requestResponse?.txnId ?? ""}",
        "imei": await AppUtil.getDeviceID(),
        "latitude": position!.latitude,
        "longitude": position!.longitude,
        "type": _transactionTypeInCode(),
      };
      var result = await NativeCall.launchMatmService(params);
      var data = MatmResult.fromJson(result);


      if (!updateToServerCalled) {
        updateToServerCalled = true;
        _updateToServer(data);
      }
    } on PlatformException catch (e) {
      _updateUnknownResponseToServer();
    } catch (e) {
      _updateUnknownResponseToServer();
    }
  }

  _updateUnknownResponseToServer() {
    if (transactionType.value == MatmTramoTransactionType.balanceEnquiry) {
      if (!updateToServerCalled) {
        updateToServerCalled = true;
        _updateToServer(MatmResult.fromJson({
          "status": false,
          "transAmount": 0.0,
          "balAmount": 0.0,
          "bankRrn": "not available",
          "time": "not available",
          "message": "not available",
          "cardNumber": "not available",
          "bankName": "not available",
        }));
      }
    } else {
      _checkIsTransactionIsInitiated();
    }
  }

  _checkIsTransactionIsInitiated() async {
    try {
      var response = await repo.isMatmInitiated({
        "clientId": transactionNumber ?? "",
        "merchantPassword": requestResponse?.loginPin ?? ""
      });

      if (response.status == 1 && !(response.isInitiated ?? true)) {
        _updateToServer(MatmResult.fromJson({
          "status": false,
          "transAmount": 0.0,
          "balAmount": 0.0,
          "bankRrn": "not available",
          "time": "not available",
          "message": response.message,
          "cardNumber": "not available",
          "bankName": "not available",
        }));
      } else {
        _updateToServer(MatmResult.fromJson({
          "status": false,
          "transAmount": 0.0,
          "balAmount": 0.0,
          "bankRrn": "",
          "time": "",
          "message": "",
          "cardNumber": "",
          "bankName": "",
        }));
      }
    } catch (e) {
      _showPendingDialog();
    }
  }

  _showPendingDialog() {
    StatusDialog.pending(
            title: "Transaction in Pending, please check transaction status")
        .then((value) => Get.offAllNamed(AppRoute.mainPage));
  }

  _updateToServer(MatmResult result) async {
    StatusDialog.progress(title: "Updating to Server");

    if (result.bankRrn == "" && result.message == "") {
      _redirectForReQueryPage = true;
    }

    try {

      String status = (result.status) ? "1" : "2";
      String message = result.message;

      final isCashWithdrawal =
          transactionType.value == MatmTramoTransactionType.cashWithdrawal;

      if (_redirectForReQueryPage && isCashWithdrawal) {
        status = "3";
        message = "Transaction in pending!";
      }

      await repo.updateMatmDataToServer({
        "status": status,
        "clientId": requestResponse!.clientId ?? "",
        "balanceamt": result.balAmount.toString(),
        "bankName": result.bankName,
        "cardNumber": result.cardNumber,
        "bankRRN": result.bankRrn,
        "message": message,
        "providerTxnId": requestResponse!.txnId ?? "",
      });

      Get.back();
    } catch (e) {
      Get.back();
    } finally {

      result.statusId = (result.status) ? 1 : 2;

      final isCashWithdrawal = transactionType.value == MatmTramoTransactionType.cashWithdrawal;

      if(result.transAmount == 0.0 && isCashWithdrawal){
        result.transAmount = double.parse(amountWithoutRupeeSymbol(amountController));
      }

      if (_redirectForReQueryPage && isCashWithdrawal) {
        result.statusId = 3;
        Get.offAll(() => const MatmInProcessPage(), arguments: {
          "result": result,
          "transaction_number": transactionNumber!
        });

      } else {
        Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
          "response": result,
          "txnType": transactionType.value
        });
      }
    }
  }

  getTransactionTypeInString() {
    switch (transactionType.value) {
      case MatmTramoTransactionType.cashWithdrawal:
        return "Cash Withdrawal";
      case MatmTramoTransactionType.balanceEnquiry:
        return "Balance Enquiry";
    }
  }

  getSpayRequestTxnType() {
    switch (transactionType.value) {
      case MatmTramoTransactionType.cashWithdrawal:
        return "CW";
      case MatmTramoTransactionType.balanceEnquiry:
        return "BE";
    }
  }

  _transactionTypeInCode() {
    switch (transactionType.value) {
      case MatmTramoTransactionType.cashWithdrawal:
        return 2;
      case MatmTramoTransactionType.balanceEnquiry:
        return 4;
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
