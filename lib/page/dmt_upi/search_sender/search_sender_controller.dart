import 'package:esmartbazaar/page/dmt_upi/beneficiary/add/qr_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/upi_repo.dart';
import 'package:esmartbazaar/data/repo_impl/upi_repo_impl.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../main/home/component/bottom_sheet_option.dart';
import '../scan_pay/upi_scan_pay_page.dart';
import 'account_list_dialog.dart';

class UpiSearchSenderController extends GetxController {
  UpiRepo repo = Get.find<UpiRepoImpl>();

  var numberController = TextEditingController();
  String? mobile = Get.arguments["mobile"];
  AppPreference appPreference = Get.find();


  var showSearchButton = false.obs;
  var isSearchingSender = false.obs;

  var searchTypeObs = UpiRemitterSearchType.mobile.obs;
  var qrResultObs = {}.obs;

  @override
  void onInit() {
    super.onInit();

    numberController.text = mobile ?? "";
    if (numberController.text.toString().length == 10) {
      showSearchButton.value = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
    if (searchTypeObs.value == UpiRemitterSearchType.mobile) {
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

      AccountSearchResponse response = await repo.searchAccount(data);
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
        searchTypeObs.value == UpiRemitterSearchType.mobile) {
      showSearchButton.value = true;
      _searchSender();
    } else if (mobileNumber.length >=10 &&
        searchTypeObs.value == UpiRemitterSearchType.account) {
      showSearchButton.value = true;
    } else {
      showSearchButton.value = false;
    }
  }

  _searchSender({AccountSearch? accountSearch,int delay = 0}) async {


    StatusDialog.progress(title: "Searching");
    await Future.delayed(Duration(seconds: delay));
    try {
      final mobile = accountSearch != null
          ? accountSearch.senderNumber!
          : numberController.text.toString();


      final data = {"mobileno": mobile};
      SenderInfo sender = await repo.searchSender(data);

      Get.back();
      if (sender.code == 1) {

        Get.bottomSheet(UpiSenderOptionDialog(
          onScanAndPay: () {
            gotoScanAndPagePage(sender,mobile);
          },
          onBeneficiaryPage: () {
            gotoBeneficiaryPage(sender, mobile, accountSearch);
          },
        ));

      }
      else if (sender.code == 2) {
        final args = {
          "mobile": mobile,
        };
        Get.toNamed(AppRoute.dmtSenderAddPage, arguments: args)?.then((value){
          if(value != null){
            _searchSender();
          }
        });
      }
      // else if (sender.code == 2) {
      //   final args = {
      //     "mobile": mobile,
      //     "isRegistered" : false,
      //   };
      //   Get.toNamed(AppRoute.upiSenderAddPage, arguments: args)?.then((value){
      //     if(value != null){
      //       _searchSender();
      //     }
      //   });
      // }
      //
      // else if (sender.code == 3) {
      //   final args = {
      //     "mobile": mobile,
      //     "isRegistered" : true,
      //   };
      //   Get.toNamed(AppRoute.upiSenderAddPage, arguments: args)?.then((value){
      //     if(value != null){
      //       _searchSender();
      //     }
      //   });
      // }

      else {
        StatusDialog.failure(title: sender.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void gotoBeneficiaryPage(SenderInfo sender, String mobile, AccountSearch? accountSearch) {
    if(sender.senderNumber == null || sender.senderNumber?.isEmpty == true) {
      sender.senderNumber = mobile;
    }
    final args = {"sender": sender, "account" : accountSearch};
    Get.toNamed(AppRoute.upiBeneficiaryListPage, arguments: args)?.then((value){
      if(value!=null){
        if(value is Map){

          numberController.text = value["mobile_number"];
          _searchSender(delay: 3);
        }
      }
    });
  }

  getInputTextFieldLabel() =>
      (searchTypeObs.value == UpiRemitterSearchType.mobile)
          ? "Remitter Mobile Number"
          : "Beneficiary upi id";

  getInputTextFielMaxLegth() =>
      (searchTypeObs.value == UpiRemitterSearchType.mobile) ? 10 : 20;

  void gotoScanAndPagePage(SenderInfo sender, String mobile) {
    Get.to(()=>const UpiScanPayPage(),arguments: {
      "sender" : sender,
      "mobile" : mobile
    });
  }
}


enum UpiRemitterSearchType{
  mobile,account
}