import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/button.dart';
import '../../../../widget/text_field.dart';
import '../common.dart';
import 'import_sender_controller.dart';

class ImportFromSenderPage extends GetView<ImportFromSenderController> {
  const ImportFromSenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ImportFromSenderController());
    return Column(
      children: [
        _searchFormWidget(),
        Obx(() => (controller.isListFetched.value)
            ? ImportBeneficiaryListWidget(
                beneficiaryList: controller.beneficiaryList,
                selectedListObs: controller.selectedListObs,
              )
            : const SizedBox()),
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

  _searchFormWidget() {
    return Form(
      child: Card(
        child: Obx(() => Padding(
              padding: const EdgeInsets.all(16.0),
              child: MobileTextField(
                label: "Remitter Mobile Number",
                onChange: controller.onMobileChange,
                controller: controller.mobileController,
                rightButton: (controller.showSearchButton.value)
                    ? (controller.isSearchingSender.value)
                        ? const CircularProgressIndicator()
                        : AppButton(
                            width: 100,
                            text: "Search",
                            onClick: () {
                              controller.onSearchClick();
                            })
                    : const SizedBox(),
              ),
            )),
      ),
    );
  }
}
