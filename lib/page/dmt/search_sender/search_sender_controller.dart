import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_util.dart';

import 'account_list_dialog.dart';

class DmtSearchSenderController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();

  var numberController = TextEditingController();
  DmtType dmtType = Get.arguments["dmtType"];
  String? mobile = Get.arguments["mobile"];
  AppPreference appPreference = Get.find();

  //GlobalKey<FormState> senderSearchFormkey = GlobalKey<FormState>();

  var showSearchButton = false.obs;
  var isSearchingSender = false.obs;

  var searchTypeObs = DmtRemitterSearchType.mobile.obs;

  @override
  void onInit() {
    super.onInit();

    numberController.text = mobile ?? "";
    if (numberController.text.toString().length == 10) {
      showSearchButton.value = true;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _searchSender();
      });
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  onSearchClick() {
    if (searchTypeObs.value == DmtRemitterSearchType.mobile) {
      _searchSender();
    } else {
      _searchBeneficiaryAccount();
    }
  }

  _searchBeneficiaryAccount() async {
    StatusDialog.progress(title: "Searching Account");
    try {
      final accountNumber = numberController.text.toString();
      final data = {"accountno": accountNumber};

      AccountSearchResponse response = (dmtType == DmtType.dmt2)
          ? await repo.searchAccountDmt2(data)
          : await repo.searchAccount(data);
      Get.back();
      if (response.code == 1) {
        Get.dialog(AccountListDialogWidget(
          accountNumber: accountNumber,
          accountList: response.accounts!,
          onAccountClick: (value) {
            Get.back();
            _searchSender(accountSearch: value);
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      AppUtil.logger(e.toString());
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onMobileChange(String value) {
    final mobileNumber = numberController.text.toString();

    if (mobileNumber.length == 10 &&
        searchTypeObs.value == DmtRemitterSearchType.mobile) {
      showSearchButton.value = true;
      _searchSender();
    } else if (mobileNumber.length > 6 &&
        searchTypeObs.value == DmtRemitterSearchType.account) {
      showSearchButton.value = true;
    } else {
      showSearchButton.value = false;
    }
  }

  _searchSender({AccountSearch? accountSearch, int delay = 0}) async {
    StatusDialog.progress(title: "Searching");
    await Future.delayed(Duration(seconds: delay));
    try {
      final mobile = accountSearch != null
          ? accountSearch.senderNumber!
          : numberController.text.toString();
      final data = {"mobileno": mobile};

      // SenderInfo sender = (dmtType == DmtType.instantPay)
      //     ? await repo.searchSender(data)
      //     : await repo.searchSenderDmt2(data);

      SenderInfo sender;
      if(dmtType == DmtType.instantPay){
        sender = await repo.searchSender(data);
      }
      else if(dmtType == DmtType.dmt3){
        sender = await repo.searchSenderDmt3(data);
      }
      else{
        sender = await repo.searchSenderDmt2(data);
      }

      sender.showNonKycDetail = sender.isKycVerified == false;

      // if(sender.isKycVerified == true){
      //   CommonResponse kycStatus = await repo.checkDmtKycStatus();
      //   if(kycStatus.kyc_dmt == false){
      //     sender.isKycVerified = false;
      //     sender.showNonKycDetail = false;
      //   }
      // }

      Get.back();

      if (sender.code == 1) {
        final args = {
          "sender": sender,
          "dmtType": dmtType,
          "account": accountSearch
        };
        Get.toNamed(AppRoute.dmtBeneficiaryListPage, arguments: args)
            ?.then((value) {
          if (value != null) {
            if (value is Map) {
              numberController.text = value["mobile_number"];
              _searchSender(delay: 3);
            }
          }
        });
      } else if (sender.code == 2) {
        if (dmtType == DmtType.instantPay) {
          final args = {
            "mobile": mobile,
            "dmtType": dmtType,
          };
          Get.toNamed(AppRoute.dmtSenderAddPage, arguments: args)
              ?.then((value) {
            if (value != null) {
              _searchSender();
            }
          });
        }
        else if(dmtType == DmtType.dmt3){
          final args = {
            "mobile": mobile,
            "dmtType": dmtType,
            "sender": sender
          };
          Get.toNamed(AppRoute.dmtSenderAddPage3, arguments: args)
              ?.then((value) {
            if (value != null) {
              _searchSender();
            }
          });
        }
        else {
          if (sender.isekyc ?? false) {
            final args = {
              "mobile": mobile,
              "dmtType": dmtType,
              "sender": sender
            };
            Get.toNamed(AppRoute.dmtSenderAddPageKyc, arguments: args)
                ?.then((value) {
              if (value != null) {
                _searchSender();
              }
            });
          }
          else {
            final args = {
              "mobile": mobile,
              "dmtType": dmtType,
              "sender": sender
            };
            Get.toNamed(AppRoute.dmtSenderAddPage2, arguments: args)
                ?.then((value) {
              if (value != null) {
                _searchSender();
              }
            });
          }
        }
      } else {
        StatusDialog.failure(title: sender.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  getInputTextFieldLabel() =>
      (searchTypeObs.value == DmtRemitterSearchType.mobile)
          ? "Remitter Mobile Number"
          : "Beneficiary Account Number";

  getInputTextFielMaxLegth() =>
      (searchTypeObs.value == DmtRemitterSearchType.mobile) ? 10 : 20;
}

enum DmtRemitterSearchType { mobile, account }
