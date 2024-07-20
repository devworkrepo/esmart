import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/exception_page.dart';

import '../common.dart';



class ImportFromSenderController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();

  SenderInfo sender = Get.arguments;
  late List<Beneficiary> beneficiaryList;

  var selectedListObs = <Beneficiary>[].obs;
  var selectedDeletedListObs = <Beneficiary>[].obs;
  List<ImportBeneficiaryMessage> importedList = [];
  var isListFetched = false.obs;



  final mobileController = TextEditingController();
  var showSearchButton = false.obs;
  var isSearchingSender = false.obs;


  onMobileChange(String value) {
    final mobileNumber = mobileController.text.toString();

    if (mobileNumber.length == 10) {
      showSearchButton.value = true;
      _searchBeneficiaries();
    } else {
      showSearchButton.value = false;
    }
  }

  void onSearchClick() {
    _searchBeneficiaries();
  }

  _searchBeneficiaries() async {
    try {
      var params = {
        "remitter_mobile": mobileController.text,
        "remitter_id": sender.senderId.toString()
      };
      StatusDialog.progress(title: "Searching...");
      var response = await repo.fetchBeneficiary(params);
      Get.back();
      if (response.code == 1) {
        beneficiaryList = response.beneficiaries!;
        isListFetched.value = true;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void importBeneficiaries() async {
    StatusDialog.progress(title: "Importing...");
    importedList.clear();
    for (var i = 0; i < selectedListObs.length; i++) {
      var beneficiary = selectedListObs.value[i];
      Future.delayed(const Duration(seconds: 2));

      try {
        var response = await _importBeneficiary(beneficiary);

        if (response.code == 1) {
          importedList
              .add(ImportBeneficiaryMessage(1, beneficiary, response.message));
        }
        else {
          importedList
              .add(ImportBeneficiaryMessage(0, beneficiary, response.message));
        }
      } catch (e) {
        importedList
            .add(ImportBeneficiaryMessage(
            0, beneficiary, "Exception failed to import"));
      }
    }
    Get.back();
    Get.back(result: importedList);
  }

  Future<CommonResponse> _importBeneficiary(Beneficiary beneficiary) async {
    try {
      var response = await repo.importRemitterBeneficiary({
        "remitter_mobile": mobileController.text,
        "from_mobile": mobileController.text,
        "remitter_id": sender.senderId ?? "",
        "beneid": beneficiary.id.toString()
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
