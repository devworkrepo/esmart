import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/aeps_repo.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/page/aeps_settlement/settlement/settlement_controller.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../../model/aeps/settlement/balance.dart';
import '../../../widget/common/common_confirm_dialog.dart';
import '../../exception_page.dart';

class SelectSettlementBankController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;
  var beneficiaryList = <AepsSettlementBank>[];
  RxList<AepsSettlementBank> beneficiaryListObs = <AepsSettlementBank>[].obs;

  var showSearchBoxObs = false.obs;

  var balanceResponseObs = Resource.onInit(data: AepsBalance()).obs;
  Rx<AepsBalance> aepsBalance = AepsBalance().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchBankList();
    });
  }

  _fetchBalance() async {
    try {
      balanceResponseObs.value = Resource.onInit();
      var response = await repo.fetchAepsBalance();
      if (response.code == 1) {

        aepsBalance.value = response;
        balanceResponseObs.value = Resource.onSuccess(response);
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong")
            .then((value) {});
      }
    } catch (e) {
      StatusDialog.failure(title: "Something went wrong")
          .then((value) => Get.back());
    }

  }


  addNewBank(bool shouldPop) {
    if (shouldPop) {
      Get.offNamed(AppRoute.addSettlementBank, arguments: false);
    } else {
      Get.toNamed(AppRoute.addSettlementBank, arguments: true)?.then((value) {
        if (value) _fetchBankList();
      });
    }
  }

  _fetchBankList() async {

    try {
     await _fetchBalance();
      responseObs.value = const Resource.onInit(data: null);
      var response = await repo.fetchAepsSettlementBank2();
        beneficiaryList = response.banks!;
        beneficiaryListObs.value = beneficiaryList;
      responseObs.value = Resource.onSuccess(response);

      if(response.code ==1 && response.banks!.isNotEmpty){
        showSearchBoxObs.value = true;
      }
      else {
        showSearchBoxObs.value = false;
      }
    } catch (e) {
      responseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }

  }

  onImportClick(){
    Get.toNamed(AppRoute.importSettlementBank)?.then((value) {
      if(value != null){
        if(value is bool && value == true){
          _fetchBankList();
        }
      }
    });
  }

  onTransferClick(AepsSettlementBank bank) {
    Get.toNamed(AppRoute.aepsBankTransferPage, arguments: {
      "bank_account": bank,
      "aeps_balance" : double.parse((aepsBalance.value.balance ?? "0"))
    })?.then((value) {
      if(value != null && value is bool){
        if(value) _fetchBankList();
      }
    });
  }

  onDeleteClick(AepsSettlementBank bank) {
    Get.dialog(CommonConfirmDialogWidget(
      onConfirm: () {
        _deleteBeneficiaryConfirm(bank);
      },
      title: "Confirm Delete",
      description: "You are sure! want to delete account ?",
    ));
  }

  void _deleteBeneficiaryConfirm(AepsSettlementBank bank) async {
    StatusDialog.progress(title: "Deleting...");
    try {

      var response = await repo.deleteBankAccount({
        "acc_id": bank.accountId.toString(),
      });
      Get.back();

      if(response.code ==1){
        StatusDialog.success(title: response.message).then((value) => _fetchBankList());
      }
      else {
        StatusDialog.alert(title: response.message);
      }

    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onSearchChange(String value) {
    List<AepsSettlementBank> results = beneficiaryList;
    if (value.isEmpty) {
      results = beneficiaryList;
    } else {
      results = beneficiaryList
          .where((item) =>
      item.accountName!.toLowerCase().contains(value.toLowerCase()) ||
          item.accountNumber!.toLowerCase().contains(value.toLowerCase())||
          item.bankName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    beneficiaryListObs.value = results;
  }
}
