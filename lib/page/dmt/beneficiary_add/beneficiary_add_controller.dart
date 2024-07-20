import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/widget/common/common_confirm_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class BeneficiaryAddController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();

  DmtType dmtType = Get.arguments["dmtType"];

  final beneficiaryAddForm = GlobalKey<FormState>();
  final mobileNumberController = TextEditingController();
  final nameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();

  var isVerifying = false.obs;
  var validateBeneNameTextController = false;

  late String bankName;

  bool isAccountVerify = false;

  var bankListResponseObs = Resource.onInit(data: BankListResponse()).obs;
  late List<Bank> bankList;

  @override
  void onInit() {
    super.onInit();
    mobileNumberController.text = Get.arguments["mobile"];
    _fetchBankList();
  }

  onProceed() async {
    validateBeneNameTextController = true;
    final isValidate = beneficiaryAddForm.currentState!.validate();
    if (!isValidate) return;

    final data = {
      "remitter_mobile": mobileNumberController.text.toString(),
      "accountno": accountNumberController.text.toString(),
      "name": nameController.text.toString(),
      "ifsc": ifscCodeController.text.toString(),
      "bankname": bankName,
      "validate_status": (isAccountVerify) ? "Success" : "Pending",
    };

    try {
      StatusDialog.progress();
      var response = await repo.addBeneficiary(data);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back(result: true));
      }
      else{
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _fetchBankList() async {
    try {
      bankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchBankList();
      bankList = response.banks;
      bankListResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      bankListResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }


  void onBankChange(String bankName) {

    Bank bank = bankList.firstWhere((element) => element.bankName == bankName);
    ifscCodeController.text = bank.ifscCode ?? "";
    this.bankName = bankName;
  }



  verifyAccountNumber() async {

    validateBeneNameTextController = false;
    final isValidate = beneficiaryAddForm.currentState!.validate();
    if (!isValidate) return;

    Get.dialog(CommonConfirmDialogWidget(
        title: "Verification ?",
        description:
        "Are you sure to verify beneficiary account number",
        onConfirm: () {
          _verify();
        }));

  }


  _verify() async {
    final data = {
      "remitter_mobile": mobileNumberController.text.toString(),
      "accountno": accountNumberController.text.toString(),
      "bankname": bankName,
      "beneid": "0",
      "ifsc": ifscCodeController.text.toString(),
    };

    try {
      isVerifying.value = true;
      final response = await repo.verifyAccount(data);
      isVerifying.value = false;
      if (response.code == 1) {
        nameController.text = response.beneficiaryName!;
        isAccountVerify = true;
        StatusDialog.success(title: response.message);
      } else {
        isAccountVerify = false;
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      isAccountVerify = false;
      isVerifying.value = false;
      StatusDialog.failure(title: "unable to verify, please try after sometime");
    }
  }
}
