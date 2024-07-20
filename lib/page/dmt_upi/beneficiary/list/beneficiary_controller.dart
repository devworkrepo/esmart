import 'package:esmartbazaar/data/app_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/list/transfer_mode_dailog.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/common/common_confirm_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';


class UpiBeneficiaryListController extends GetxController {
  final Map<String, dynamic> args = Get.arguments;

  Beneficiary? previousBeneficiary;
  AppPreference preference = Get.find();

  AccountSearch? accountSearch = Get.arguments["account"];

  UpiRepo repo = Get.find<UpiRepoImpl>();

  var beneficiaryResponseObs =
      Resource.onInit(data: DmtBeneficiaryResponse()).obs;

  var beneficiaryList = <Beneficiary>[];
  RxList<Beneficiary> beneficiaryListObs = <Beneficiary>[].obs;

  SenderInfo? sender = Get.arguments["sender"];

  void onBeneficiaryClick(Beneficiary beneficiary) {
    if (previousBeneficiary == null) {
      beneficiary.isExpanded.value = true;
      previousBeneficiary = beneficiary;
    } else if (previousBeneficiary! == beneficiary) {
      beneficiary.isExpanded.value = !beneficiary.isExpanded.value;
      previousBeneficiary = null;
    } else {
      beneficiary.isExpanded.value = true;
      previousBeneficiary?.isExpanded.value = false;
      previousBeneficiary = beneficiary;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBeneficiary();
  }

  fetchBeneficiary() async {
    _fetchBeneficiary();
  }

  _fetchBeneficiary() async {
    try {
      beneficiaryResponseObs.value = const Resource.onInit(data: null);
      var response = await repo
          .fetchBeneficiary({"remitter_mobile": sender!.senderNumber!});

      if (accountSearch != null) {
        var data = response.beneficiaries!.firstWhere(
            (element) => element.accountNumber == accountSearch!.accountNumber);
        beneficiaryList = [data];
        beneficiaryListObs.value = beneficiaryList;
      }
      else {
        beneficiaryList = response.beneficiaries!;
        beneficiaryListObs.value = beneficiaryList;
      }
      beneficiaryResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      beneficiaryResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  deleteBeneficiary(Beneficiary beneficiary) async {
    Get.dialog(CommonConfirmDialogWidget(
      onConfirm: () {
        _deleteBeneficiaryConfirm(beneficiary);
      },
      title: "Confirm Delete",
      description: "You are sure! want to delete beneficiary.",
    ));
  }

  void _deleteBeneficiaryConfirm(Beneficiary beneficiary) async {
    StatusDialog.progress(title: "Deleting");

    var response =
        await repo.beneficiaryDelete({"beneid": beneficiary.id.toString()});
    Get.back();

    if (response.code == 1) {
      StatusDialog.success(title: response.message).then((value) {
        if (accountSearch == null) {
          fetchBeneficiary();
        } else {
          beneficiaryList.removeAt(0);
          beneficiaryListObs.removeAt(0);
          accountSearch = null;
        }
      });
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  verifyAccount(Beneficiary beneficiary) async {
    Get.dialog(CommonConfirmDialogWidget(
        title: "Verification ?",
        description: "Are you sure to verify beneficiary account number",
        onConfirm: () {
          _verify(beneficiary);
        }));
  }

  _verify(Beneficiary beneficiary) async {
    try {
      StatusDialog.progress(title: "verifying");
      var response = await repo.verifyAccount({
        "remitter_mobile": sender!.senderNumber ?? "",
        "accountno": beneficiary.accountNumber ?? "",
        "ifsc": beneficiary.ifscCode ?? "",
        "beneid": beneficiary.id ?? "",
        "bankname": beneficiary.bankName ?? "",
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(
                title:
                    response.message + "\n" + (response.beneficiaryName ?? ""))
            .then((value) => fetchBeneficiary());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.failure(
          title: "unable to verify, please try after sometime");
    }
  }

  RxBool showAvailableTransferLimitObs = false.obs;

  showAvailableTransferLimit() {
    showAvailableTransferLimitObs.value = true;
  }

  onSendButtonClick(Beneficiary beneficiary) {
    Get.bottomSheet(
        UpiTransferAmountDialog(
          senderInfo: sender!,
          beneficiary: beneficiary,
          onClick: (amount) {
            Get.toNamed(AppRoute.upiTransactionPage, arguments: {
              "sender": sender,
              "beneficiary": beneficiary,
              "amount": amount,
            });
          },
        ),
        isScrollControlled: true);
  }

  onNameChange() {
    Get.toNamed(AppRoute.dmtChangeSenderNamePage, arguments: {"sender": sender})
        ?.then((value) {
      if (value != null) {
        Get.back(result: {"mobile_number": sender!.senderNumber!});
      }
    });
  }

  onMobileChange() {
    Get.toNamed(AppRoute.dmtChangeSenderMobilePage,
        arguments: {"sender": sender})?.then((value) {
      if (value != null) {
        var mobile = value as String;
        Get.back(result: {"mobile_number": mobile});
      }
    });
  }

  syncBeneficiary() async {}

  addBeneficiary() {
    Get.toNamed(AppRoute.upiBeneficiaryAddPage,
            arguments: { "mobile": sender!.senderNumber!})
        ?.then((value) {
      if (value) {
        accountSearch = null;
        _fetchBeneficiary();
      }
    });
  }

  List<BeneficiaryListPopMenu> popupMenuList() {
    var mList = [
      BeneficiaryListPopMenu(
          title: "Import Beneficiary", icon: Icons.import_export),
      BeneficiaryListPopMenu(title: "Sync Beneficiary", icon: Icons.sync),
    ];
    if ((sender?.showNonKycDetail == true)) {
      mList.add(
          BeneficiaryListPopMenu(title: "Do Kyc", icon: Icons.qr_code_scanner));
    }
    return mList;
  }

  onSearchChange(String value) {
    List<Beneficiary> results = beneficiaryList;
    if (value.isEmpty) {
      results = beneficiaryList;
    } else {
      results = beneficiaryList
          .where((item) =>
              item.name!.toLowerCase().contains(value.toLowerCase()) ||
              item.accountNumber!.toLowerCase().contains(value.toLowerCase())||
              item.bankName!.toLowerCase().contains(value.toLowerCase()))
          .toList();

      AppUtil.logger("value : $value");
      AppUtil.logger(results);
    }
    beneficiaryListObs.value = results;
  }
}

class BeneficiaryListPopMenu {
  final String title;
  final IconData icon;

  BeneficiaryListPopMenu({required this.title, required this.icon});
}
