import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/beneficiary_imported_dialog.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/transfer_mode_dailog.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/common/common_confirm_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../import_beneficiary/common.dart';

class BeneficiaryListController extends GetxController {
  final Map<String, dynamic> args = Get.arguments;

  Beneficiary? previousBeneficiary;

  AccountSearch? accountSearch = Get.arguments["account"];

  DmtRepo repo = Get.find<DmtRepoImpl>();

  var beneficiaryResponseObs =
      Resource.onInit(data: DmtBeneficiaryResponse()).obs;

  var beneficiaryList = <Beneficiary>[];
  RxList<Beneficiary> beneficiaryListObs = <Beneficiary>[].obs;

  SenderInfo? sender = Get.arguments["sender"];
  DmtType dmtType = Get.arguments["dmtType"];

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
      } else {
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
        TransferModeDialog(
          isLimitView: showAvailableTransferLimitObs.value,
          senderInfo: sender!,
          beneficiary: beneficiary,
          dmtType: dmtType,
          onClick: (amount, type) {
            Get.toNamed(AppRoute.dmtTransactionPage, arguments: {
              "sender": sender,
              "beneficiary": beneficiary,
              "dmtType": dmtType,
              "type": type,
              "amount": amount,
              "isView":
                  (showAvailableTransferLimitObs.value == true) ? "1" : "0",
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
    Get.toNamed(AppRoute.dmtBeneficiaryAddPage,
            arguments: {"dmtType": dmtType, "mobile": sender!.senderNumber!})
        ?.then((value) {
      if (value) {
        accountSearch = null;
        _fetchBeneficiary();
      }
    });
  }

  void fetchKycInfo() async {
    Get.toNamed(AppRoute.senderKycInfoPage, arguments: {
      "dmt_type": dmtType,
      "mobile_number": sender!.senderNumber!
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

  onSelectPopupMenu(BeneficiaryListPopMenu i) {
    if (i.title == "Kyc Info") {
      fetchKycInfo();
    }
    if (i.title == "Do Kyc") {
      Get.toNamed(AppRoute.senderKycPage, arguments: {
        "dmt_type": dmtType,
        "mobile_number": sender!.senderNumber!
      });
    } else if (i.title == "Sync Beneficiary") {
      _syncBeneficiary();
    } else if (i.title == "Import Beneficiary") {
      Get.toNamed(AppRoute.dmtImportBeneficiaryPage, arguments: sender!)
          ?.then((value) {
        if (value != null) {
          if (value is List<ImportBeneficiaryMessage>) {
            if (value.isNotEmpty) {
              Get.bottomSheet(BeneficiaryImportedDialog(value),
                      isScrollControlled: true)
                  .then((value) {
                _fetchBeneficiary();
              });
            }
          }
        }
      });
    }
  }

  _syncBeneficiary() async {
    try {
      StatusDialog.progress(title: "Synchronizing Beneficiaries");

      var response = await repo.syncBeneficiary({
        "remitterid": sender?.senderId ?? "",
        "mobileno": sender?.senderNumber ?? "",
      });

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => _fetchBeneficiary());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
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
