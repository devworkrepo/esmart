import 'dart:io';

import 'package:esmartbazaar/data/repo/aeps_fing_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_fing_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
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
import '../../../util/xml_pid_parser.dart';
import '../transaction_type.dart';

class AepsFingController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AepsFingRepo repo = Get.find<AepsFingRepoImpl>();
  AppPreference appPreference = Get.find();

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  var aepsFormKey = GlobalKey<FormState>();
  var aadhaarNumberController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();

  late List<AepsBank> bankList;

  AepsBank? selectedAepsBank;

  var aepsTransactionType = AepsTransactionType.cashWithdrawal.obs;

  late AepsBankResponse bankListResponse;

  getTitle() => "AEPS - 2";

  var requireAuth = true.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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

        if (!(response.isEKcy ?? false)) {
          showEkcyDialog(
              "E-Kyc is Required.",
              "To do aeps, aadhaar pay and matm transaction E-Kyc is required!",
              AppRoute.aepsEkycPage);
        } else {
          var mResponse =  await repo.checkDaily2FAuth();
          if (mResponse.code == 1) {
            requireAuth.value = false;
          } else {
            requireAuth.value = true;
          }
          aepsBankListResponseObs.value = Resource.onSuccess(response);
        }
      } else if (response.code == 2) {
        showEkcyDialog(
          "OnBoarding Required",
          response.message ??
              "To do aeps, aadhaar pay and matm transaction"
                  " OnBoarding is required!",
          AppRoute.aepsOnboardingFingPage,
        );
      } else if (response.code == 3) {
        StatusDialog.pending(
                title: response.message ?? "Pending",
                buttonText: "Bank to Home")
            .then((value) => Get.back());
      } else {
        validateLocation(progress: false);

        if (selectedAepsBank != null) {}
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
              Get.offAndToNamed(route, arguments: true);
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
    if (!requireAuth.value) {
      var isValidate = aepsFormKey.currentState!.validate();
      if (!isValidate) return;
    }
    try {
      await validateLocation(progress: true);
      if (position == null) return;
    } catch (e) {
      return;
    }

    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {

          var result = await NativeCall.launchResultForAEPSData({
            "packageUrl": rdServicePackageUrl,
            "isTransaction": true
          });

          var xmlResult = XmlPidParser.parse(result);
          _onRdServiceResult(xmlResult);
        } on PlatformException catch (e) {
          StatusDialog.failure(
              title: "Fingerprint capture failed, please try again");
        } catch (e) {
          Get.dialog(ExceptionPage(error: e));
        }
      },
    ));
  }

  void _proceedF2FAuth(Map<dynamic,dynamic> data) async {

    var _param = <String, String>{
      "IIN": selectedAepsBank?.id ?? "",
      "bankName" : selectedAepsBank?.name ?? "",
      "latitude": position!.latitude.toString(),
      "longitude": position!.longitude.toString(),
      "transactionno":"",
      "devicename":"",
      "Piddata": data["Data"].toString(),
      "dc": data["DeviceInfoDC"],
      "ci": data["SkeyCI"],
      "hmac": data["Hmac"],
      "dpId": data["DeviceInfoDpId"],
      "mc": data["DeviceInfoMC"],
      "skey": data["Skey"],
      "mi": data["DeviceInfoMI"],
      "rdsId": data["DeviceInfoRdsId"],
      "devicesrno": data["srno"],
      "sysid": data["sysid"],
      "ts": data["ts"],
      "pidData": data["Data"],
      "qScore": data["qScore"],
      "nmPoints": data["nmPoints"],
      "PidDatatype": data["DataType"],
      "capturesessionKey": data["Skey"],
      "rdsVer": data["DeviceInfoRdsVer"]
    };
    try {
      StatusDialog.progress();
      var response = await repo.proceedDaily2FAuth(_param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          _fetchBankList();
        });
      } else {
        StatusDialog.alert(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(
          error: e,
          data: {"param": _param, "transaction_type": "Aeps Transaction"}));
    }
  }

  _onRdServiceResult(Map<String,String> data) async {
    if (requireAuth.value) {
      _proceedF2FAuth(data);
      return;
    }

    var transactionType = "";
    if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal) {
      transactionType = "Cash Withdrawal";
    } else if (aepsTransactionType.value ==
        AepsTransactionType.balanceEnquiry) {
      transactionType = "Balance Enquiry";
    }

    var isAmountNull = (
            aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
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

  _aepsTransaction(Map<String,String> data) async {


    final _param = {

      "bankiin": selectedAepsBank?.id ?? "",
      "bankName": selectedAepsBank?.name ?? "",
      "txntype": _transactionTypeInCode(),
      "devicetype": appPreference.rdService,
      "amount": (aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
          ? amountWithoutRupeeSymbol(amountController)
          : "0",
      "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
      "mobileno": mobileController.text.toString(),
      "latitude": position!.latitude.toString(),
      "longitude": position!.longitude.toString(),
      "bcid": bankListResponse.bcid ?? "",
      "transaction_no": bankListResponse.transactionNumber ?? "",
      "Piddata": data["Data"].toString(),
      "dc": data["DeviceInfoDC"],
      "ci": data["SkeyCI"],
      "hmac": data["Hmac"],
      "dpId": data["DeviceInfoDpId"],
      "mc": data["DeviceInfoMC"],
      "skey": data["Skey"],
      "capturesessionKey": data["Skey"],
      "mi": data["DeviceInfoMI"],
      "rdsId": data["DeviceInfoRdsId"],
      "deviceSerialNumber": data["srno"],
      "sysid": data["sysid"],
      "ts": data["ts"],
      "pidData": data["Data"],
      "qScore": data["qScore"],
      "nmPoints": data["nmPoints"],
      "PidDatatype": data["DataType"],
      "rdsVer": data["DeviceInfoRdsVer"]
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
