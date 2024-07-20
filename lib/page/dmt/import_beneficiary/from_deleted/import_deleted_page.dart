import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../../widget/button.dart';
import '../common.dart';
import 'import_deleted_controller.dart';

class ImportFromDeletedPage extends GetView<ImportFromDeletedController> {
  const ImportFromDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ImportFromDeletedController());
    return Column(
      children: [
        ObsResourceWidget(
            obs: controller.responseObs,
            childBuilder: (data) => ImportBeneficiaryListWidget(
                  beneficiaryList: controller.beneficiaryList,
                  selectedListObs: controller.selectedListObs,
                )),
        Obx(() => controller.selectedListObs.isNotEmpty
            ? AppButton(
                text: "Import",
                onClick: () {
                  controller.importBeneficiaries();
                })
            : const SizedBox())
      ],
    );
  }
}
