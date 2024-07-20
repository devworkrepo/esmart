import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/aeps_aitel_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_aitel_impl.dart';
import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/page/aeps/widget/ekyc_info_widget.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/response/aeps/aeps_txn_response_page.dart';
import 'package:esmartbazaar/service/native_call.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/widget/dialog/aeps_rd_service_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';

import '../../../route/route_name.dart';
import '../../../util/mixin/location_helper_mixin.dart';
import '../transaction_type.dart';

class AepsAirtelController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AepsAirtelRepo repo = Get.find<AepsAirtelRepoImpl>();
  AppPreference appPreference = Get.find();

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  var aepsFormKey = GlobalKey<FormState>();
  var aadhaarNumberController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();

  late List<AepsBank> bankList;

  AepsBank? selectedAepsBank;
  String? token;

  var aepsTransactionType = AepsTransactionType.cashWithdrawal.obs;

  late AepsBankResponse bankListResponse;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchBankList();
      validateLocation(progress: false);
    });
  }

  void _fetchBankList() async {
    try {
      aepsBankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsBankList();
      if (response.code == 1) {
        bankListResponse = response;
        bankList = response.aepsBankList!;
        aepsBankListResponseObs.value = Resource.onSuccess(response);

        _checkToken();
      } else if (response.code == 2) {
        showEkcyDialog(
          "OnBoarding Required",
          response.message ??
              "To do aeps, aadhaar pay and matm transaction"
                  " OnBoarding is required!",
          AppRoute.aepsOnboardingPage,
          false,
        );
      } else if (response.code == 3) {
        StatusDialog.alert(title: response.message.toString())
            .then((value) => Get.offAllNamed(AppRoute.mainPage));
      } else {
        validateLocation(progress: false);
        if (selectedAepsBank != null) {}
      }
    } catch (e) {
      aepsBankListResponseObs.value = Resource.onFailure(e);
    }
  }

  void _checkToken() async {
    StatusDialog.progress();
    try {
      final result = await repo.checkToken();
      Get.back();
      token = result.token;
      if (result.code == 1) {
      } else if (result.code == 2) {
        showEkcyDialog("Token Expired!", result.message,
            AppRoute.aepsAirtelKycPage, token);
      } else {
        StatusDialog.alert(title: result.message).then((value) => Get.back());
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void showEkcyDialog(
      String title, String message, String route, dynamic args) {
    Get.bottomSheet(
        EkycInfoWidget(
            title: title,
            message: message,
            onClick: () {
              Get.back();
              Get.offAndToNamed(route, arguments: args);
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
    var isValidate = aepsFormKey.currentState!.validate();
    if (!isValidate) return;
    try {
      await validateLocation(progress: true);
      if (position == null) return;
    } catch (e) {
      return;
    }

    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchAirtelAepsService({
            "packageUrl": rdServicePackageUrl,
            "isTransaction": true,
            "provider": "airtel"
          });

          if (result["pidData"].toString().trim() == "") {
            StatusDialog.alert(
                title: "Fingerprint capture failed! Please try again!");
          } else {
            _onRdServiceResult(result);
          }
        } on PlatformException catch (e) {
          StatusDialog.failure(
              title: "Fingerprint capture failed, please try again");
        } catch (e) {
          Get.dialog(ExceptionPage(error: e));
        }
      },
    ));
  }

  _onRdServiceResult(Map<dynamic, dynamic> data) async {
    var transactionType = "";
    if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal) {
      transactionType = "Cash Withdrawal";
    } else if (aepsTransactionType.value ==
        AepsTransactionType.balanceEnquiry) {
      transactionType = "Balance Enquiry";
    }

    var isAmountNull =
        (aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
            ? false
            : true;

    Get.dialog(AmountConfirmDialogWidget(
        amount: (isAmountNull) ? null : amountController.text.toString(),
        detailWidget: [
          ListTitleValue(
              title: "Aadhaar No.",
              value: aadhaarNumberController.text.toString()),
          ListTitleValue(title: "Txn Type", value: transactionType),
          ListTitleValue(
              title: "Bank Name", value: selectedAepsBank?.name ?? ""),
        ],
        onConfirm: () {
          _aepsTransaction(data);
        }));
  }

  _aepsTransaction(Map<dynamic, dynamic> data) async {
    final String hMac = data["hMac"];
    final String pidData = data["pidData"];
    final String deviceCode = data["deviceCode"];
    final String modelId = data["modelId"];
    final String providerCode = data["providerCode"];
    final String certificateCode = data["certificateCode"];
    final String serviceId = data["serviceId"];
    final String deviceVersion = data["deviceVersion"];
    final String sKey = data["sKey"];
    final String sKeyCI = data["sKeyCI"];
    final String deviceSerialNumber = data["deviceSerialNumber"];

    var _param = <String, String>{
      "transaction_no": bankListResponse.transactionNumber ?? "",
      "txntype": _transactionTypeInCode(),
      "bcid": bankListResponse.bcid ?? "",
      "amount":
          (aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
              ? amountWithoutRupeeSymbol(amountController)
              : "0",
      "bankiin": selectedAepsBank?.id ?? "",
      "bankName": selectedAepsBank?.name ?? "",
      "mobileno": mobileController.text.toString(),
      "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
      "devicetype": appPreference.rdService,
      "ci": sKeyCI,
      "hmac": hMac,
      "Piddata": pidData,
      "devicecode": deviceCode,
      "modelid": modelId,
      "providercode": providerCode,
      "certicode": certificateCode,
      "serviceid": serviceId,
      "devicever": deviceVersion,
      "Skey": sKey,
      "srno": deviceSerialNumber,
      "token": token ?? "",
      "latitude": position!.latitude.toString(),
      "longitude": position!.longitude.toString(),
    };

    try {
      StatusDialog.transaction();
      var response = await repo.aepsTransaction(_param);
      Get.back();
      if (response.code == 1) {
        Get.to(() => AepsTxnResponsePage(), arguments: {
          "response": response,
          "aeps_type": aepsTransactionType.value,
          "isAadhaarPay": false
        })?.then((value) => _fetchBankList());
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(
        error: e,
        data: {"param": _param, "transaction_type": "Aeps Transaction"},
      ));
    }
  }

  _transactionTypeInCode() {
    switch (aepsTransactionType.value) {
      case AepsTransactionType.cashWithdrawal:
        return "CW";
      case AepsTransactionType.balanceEnquiry:
        return "BE";
    }
  }

  @override
  void dispose() {
    aadhaarNumberController.dispose();
    mobileController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
