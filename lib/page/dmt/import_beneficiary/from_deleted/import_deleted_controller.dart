import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';

import '../common.dart';

class ImportFromDeletedController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();

  SenderInfo sender = Get.arguments;
  late List<Beneficiary> beneficiaryList;
  var selectedListObs = <Beneficiary>[].obs;
  var responseObs = Resource
      .onInit(data: DmtBeneficiaryResponse())
      .obs;
  List<ImportBeneficiaryMessage> importedList = [];


  @override
  void onInit() {
    super.onInit();
    _searchDeletedBeneficiary();
  }

  _searchDeletedBeneficiary() async {
    try {
      var params = {
        "remitter_mobile": sender.senderNumber ?? "",
        "remitter_id": sender.senderId.toString()
      };
      obsResponseHandler<DmtBeneficiaryResponse>(obs: responseObs,
          apiCall: repo.fetchDeletedBeneficiary(params),
          onResponse:(value){
        beneficiaryList  = value.beneficiaries!;
          });
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
        } else {
          importedList
              .add(ImportBeneficiaryMessage(0, beneficiary, response.message));
        }
      } catch (e) {
        importedList.add(ImportBeneficiaryMessage(
            0, beneficiary, "Exception failed to import"));
      }
    }
    Get.back();
    Get.back(result: importedList);
  }

  Future<CommonResponse> _importBeneficiary(Beneficiary beneficiary) async {
    try {
      var response = await repo.importDeletedBeneficiary({
        "remitter_mobile": sender.senderNumber ?? "",
        "from_mobile": sender.senderNumber ?? "",
        "remitter_id": sender.senderId ?? "",
        "beneid": beneficiary.id.toString()
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
