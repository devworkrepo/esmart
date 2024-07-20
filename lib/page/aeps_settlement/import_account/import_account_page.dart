import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/page/aeps_settlement/import_account/list_item.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../../widget/button.dart';
import '../../../widget/no_data_found.dart';
import 'import_account_controller.dart';

class ImportSettlementAccountPage extends GetView<ImportSettlementAccountController> {
  const ImportSettlementAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ImportSettlementAccountController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Deleted Accounts"),
      ),
      body: Column(
        children: [
          ObsResourceWidget<AepsSettlementBankListResponse>(
              obs: controller.responseObs,
              childBuilder: (data) {
                if (data.code == 1) {
                  if (data.banks!.isNotEmpty) {
                    return ImportSettlementBankListWidget(
                      beneficiaryList: controller.beneficiaryList,
                      selectedListObs: controller.selectedListObs,
                    );
                  } else {
                    return Expanded(child: const NoItemFoundWidget());
                  }
                } else if (data.code == 2) {
                  return Expanded(child: const NoItemFoundWidget());
                } else {
                  return Expanded(
                    child: NoItemFoundWidget(
                      icon: Icons.info,
                      message: data.message,
                    ),
                  );
                }
              } ),
          Obx(() => controller.selectedListObs.isNotEmpty
              ? AppButton(
              text: "Import",
              onClick: () {
                controller.importBeneficiaries();
              })
              : const SizedBox())
        ],
      ),
    );
  }
}
