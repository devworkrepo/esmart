import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/credit_card/credit_card_controller.dart';
import 'package:esmartbazaar/page/credit_card/widget/card_info_widget.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../widget/common/wallet_widget.dart';
import '../../widget/drop_down.dart';

class CreditCardPage extends GetView<CreditCardController> {
  const CreditCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreditCardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credit Card Payment"),
      ),
      body: ObsResourceWidget(
          obs: controller.initialObs, childBuilder: (data) => _buildBody()),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildTopSection(),
                            Obx(() => (controller.actionType.value ==
                                    CreditCardActionType.payment)
                                ? const CardInfoWidget()
                                : const SizedBox()),
                            const SizedBox(
                              height: 16,
                            ),

                          ],
                        ),
                      ),
                    ),
                    _buildFormWidget(),
                    Obx(() => (controller.actionType.value ==
                            CreditCardActionType.payment)
                        ? const WalletWidget()
                        : const SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => AppButton(
              text: (controller.actionType.value == CreditCardActionType.fetch)
                  ? "Fetch Credit Info"
                  : "Pay Credit Bill",
              onClick: controller.onProceed,
            ))
      ],
    );
  }

  _buildTopSection() {
    return Row(
      children: [
        const AppCircleAssetPng(
          "assets/image/card.png",
          size: 60,
          innerPadding: 8,
        ),
        Expanded(
          child: Text(
            "Credit Card Bill Payment",
            style:
                Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _buildFormWidget() {
    return Obx(() {
      var isEnable =
          controller.actionType.value == CreditCardActionType.fetch;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CardTextField(
                controller: controller.numberController,
                enable: isEnable,
              ),
              MobileTextField(
                controller: controller.mobileController,
                enable: isEnable,
              ),
              AppTextField(
                enable: isEnable,
                controller: controller.nameController,
                label: "Card Holder Name",
                validator: FormValidatorHelper.normalValidation,
              ),
            ],),
          ),),
         Card(child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(children: [
             AppDropDown(
               list: controller.typeList,
               onChange: (value) {
                 controller.selectedType = controller.typeList
                     .firstWhere((element) => element == value);
               },
               selectedItem: (controller.selectedType.isNotEmpty)
                   ? controller.selectedType
                   : null,
               label: "Select Card Type",
             ),
             AppDropDown(
               list: controller.bankList.map((e) => e.bankName).toList(),
               onChange: (value) {
                 controller.selectedBank = controller.bankList
                     .firstWhere((element) => element.bankName == value);
                 controller.ifscCodeController.text =
                     controller.selectedBank?.ifscCode ?? "";
               },
               selectedItem: (controller.selectedBank != null)
                   ? controller.selectedBank!.bankName
                   : null,
               label: "Select Bank",
             ),
             AppTextField(
               maxLength: 11,
               controller: controller.ifscCodeController,
               label: "IFSC Code",
               validator: (value) =>
                   FormValidatorHelper.normalValidation(value, minLength: 11),
             ),
           ],),
         ),)
        ],
      );
    });
  }
}
