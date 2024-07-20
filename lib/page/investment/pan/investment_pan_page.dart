import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/investment/pan/investment_pan_controller.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class InvestmentPanPage extends GetView<InvestmentPanController> {
  const InvestmentPanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentPanController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Pan Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              _buildPanVerifyWidget(),
              Obx(() => (controller.panName.value.isNotEmpty)
                  ? _uploadPanCardWidget()
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  Card _buildPanVerifyWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify Pan Number",
              style: Get.textTheme.headline6,
            ),
            AppTextField(
              controller: controller.panInputController,
              label: "Pan Number",
              hint: "10 characters pan number",
              maxLength: 10,
              validator: (value) => FormValidatorHelper.isValidPanCardNo(value),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name in PAN :-",
                      style: Get.textTheme.caption
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Obx(() => Text(
                          controller.panName.value,
                          style: Get.textTheme.subtitle1,
                        )),
                  ],
                )),
                SizedBox(
                  width: 16,
                ),
                TextButton(
                    onPressed: () {
                      controller.verifyPanNumber();
                    },
                    child: const Text("Verify Pan"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _uploadPanCardWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload Pan Image",
              style: Get.textTheme.headline6,
            ),
            AppTextField(
              label: "Pan Photo",
              controller: controller.docPanController,
              onFieldTab: () {
                controller.showImagePickerBottomSheetDialog();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    onPressed: () {
                      controller.onSubmit();
                    }, child: const Text("Upload Pan")))
          ],
        ),
      ),
    );
  }
}
