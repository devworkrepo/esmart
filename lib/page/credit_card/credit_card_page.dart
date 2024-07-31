import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/credit_card/credit_card_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../widget/common/amount_background.dart';
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            _buildTopSection(),
                            const SizedBox(
                              height: 16,
                            ),

                          ],
                        ),
                      ),
                    ),
                    _buildFormWidget(),
                   const WalletWidget()

                  ],
                ),
              ),
            ),
          ),
        ),
        AppButton(
              text:  "Pay Credit Bill",
              onClick: controller.onProceed,
            )
      ],
    );
  }

  _buildTopSection() {
    return Row(
      children: [
        const AppCircleAssetPng(
          "assets/image/card.png",
          size: 40,
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

      var isEnable = true;
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
              SizedBox(height: 5,),
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
            ],),
          ),),
         Card(child: Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(children: [

             SizedBox(height: 12,),
             AmountBackgroundWidget(
                 child: Column(children: [
                   AmountTextField(
                       label: "Bill Amount",
                       validator: (value) => FormValidatorHelper.amount(value,minAmount: 100,maxAmount: 500000),
                       controller: controller.amountController),
                   MPinTextField(controller: controller.mpinController)
                 ],)),

           ],),
         ),)
        ],
      );

  }
}
