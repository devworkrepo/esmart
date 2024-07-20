import 'package:dio/dio.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/add/qr_view.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';

import '../../../data/app_pref.dart';
import '../../../model/dmt/response.dart';
import '../../../util/security/encription.dart';
import '../../../util/validator.dart';
import '../../../widget/common/confirm_amount_dialog.dart';
import '../../../widget/dialog/status_dialog.dart';
import '../../../widget/list_component.dart';
import '../../exception_page.dart';
import '../../response/dmt/dmt_txn_response_page.dart';



class UpiScanAndPayController extends GetxController with TransactionHelperMixin {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  SenderInfo sender = Get.arguments["sender"];
  String mobile = Get.arguments["mobile"];

  UpiRepo repo = Get.find<UpiRepoImpl>();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();

  AppPreference preference = Get.find();


  var qrResultObs = {
    "isScanned" : false,
    "name" : "",
    "upiId" : "",
  }.obs;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(qrResultObs["isScanned"] == false){
        Get.to(()=>const QRCodeScannerPage())?.then((value){
          if(value == null) {
            Get.back();
          }
          else{
            onScanResult(value);
          }
        });
      }
    });

  }

  onScanResult(result){
    if(result == null) return;
    qrResultObs.value = {
      "isScanned" : true,
      "name" : result["name"].toString(),
      "upiId" : result["upiId"].toString(),
    };
  }

  proceedTransaction()  async {
    if(!formKey.currentState!.validate()) return;

    _confirmDialog();

  }

  _confirmDialog() {
    var widgetList = <ListTitleValue>[];

    widgetList = [
      ListTitleValue(title: "Name", value: qrResultObs["name"].toString()),
      ListTitleValue(title: "Upi Id", value: qrResultObs["upiId"].toString()),

    ];

    Get.dialog(AmountConfirmDialogWidget(
        amount: amountController.text.toString(),
        detailWidget: widgetList,
        onConfirm: () {
          _upiTransfer();
        }));
  }

  _getTransactionParam() async{
    final amount = amountWithoutRupeeSymbol(amountController);
    final transactionNumberResult = await repo.fetchTransactionNumber();
    final upiId = qrResultObs["upiId"].toString();
    final name = qrResultObs["name"].toString();
    final param = {
      "trans_no" : transactionNumberResult.transactionNumber,
      "remitter_mobile" : mobile,
      "benename" :name,
      "upiid" : upiId,
      "transfer_amt" : amount,
      "mpin" :  Encryption.encryptMPIN(mpinController.text)
    };
    return param;
  }

  _upiTransfer() async{
    final amount = amountWithoutRupeeSymbol(amountController);
    StatusDialog.transaction();
    final param = await _getTransactionParam();
    try {
      cancelToken = CancelToken();


      DmtTransactionResponse response;


      response = await repo.transactionDirect(param, cancelToken);

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
      await preference.setIsTransactionApi(true);
      Get.back();

      Get.dialog(ExceptionPage(
        error: e,
        data: {
          "param": param,
          "amount" : amount,
          "transaction_type": "UPI"
        },

      ));
    }

  }

  amountValidation(String? value) {

    if(value == null) return "Enter valid amount";

    final amount = double.parse(preference.user.availableBalance.toString());
    final enteredAmount = double.parse(value.toString());

    if(enteredAmount > amount){
      return "Insufficient available balance!";
    }

    return FormValidatorHelper.amount(value,minAmount: 100,maxAmount: int.parse(sender.perentry_limit.toString()));
  }
}
