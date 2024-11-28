import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/repo/dmt_repo.dart';
import '../../../data/repo/home_repo.dart';
import '../../../data/repo_impl/dmt_repo_impl.dart';
import '../../../data/repo_impl/home_repo_impl.dart';
import '../../../model/dmt/sender_info.dart';
import '../../../service/native_call.dart';
import '../../../util/mixin/transaction_helper_mixin.dart';
import '../../../widget/dialog/aeps_rd_service_dialog.dart';
import '../../../widget/dialog/status_dialog.dart';
import '../../exception_page.dart';
import '../dmt.dart';


class SenderAddKycController extends GetxController with TransactionHelperMixin {
  DmtRepo repo = Get.find<DmtRepoImpl>();
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DmtType dmtType = Get.arguments["dmtType"];
  SenderInfo sender = Get.arguments["sender"];
  String mobile = Get.arguments["mobile"];

  final  aadhaarController = TextEditingController();


  captureFingerprint() {

    if(!formKey.currentState!.validate()){
      return;
    }
      Get.dialog(AepsRdServiceDialog(
        onClick: (rdServicePackageUrl) async {
          try {
            var result = await NativeCall.launchForDmtTwoAuthPidXmlData({
              "packageUrl": rdServicePackageUrl,
            });
            _onRdServiceResult(result);

          } on PlatformException catch (e) {
            var description =
                "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

            Get.snackbar("Aeps Capture failed", description,
                backgroundColor: Colors.red, colorText: Colors.white);
          } catch (e) {
            Get.dialog(ExceptionPage(error: e));
          }
        },
      ),);

  }

  _onRdServiceResult(String result) async {

    StatusDialog.progress();

    final mResponse = await homeRepo.getTransactionNumber();
    final transactionNumber =  mResponse.transactionNumber;

      final authParams = {
        "mobileno" : mobile,
        "aadharno" : aadhaarWithoutSymbol(aadhaarController),
        "xmldata" : result,
        "lat": "12.2342",
        "lng": "92.12321",
        "transno" : transactionNumber.toString(),
      };

    try{
      var response = await repo.senderRegistrationKyc(authParams);

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          Get.back(result: {"mobile_number": mobile});
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    }catch(e){
      Get.back();
      final formattedAuthParams = const JsonEncoder.withIndent('  ').convert(authParams);
      StatusDialog.alert(title: formattedAuthParams);
    }
  }
}