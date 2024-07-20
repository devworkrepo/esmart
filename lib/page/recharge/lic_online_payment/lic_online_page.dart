import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/recharge/lic_online_payment/lic_online_controller.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:esmartbazaar/widget/common/wallet_widget.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class LicOnlinePagePage extends GetView<LicOnlineController> {
  const LicOnlinePagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LicOnlineController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("LIC Premium Bill Pay"),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFormKey(),
                  Obx(() {
                    if (controller.actionType.value ==
                        LicOnlineActionType.payBill) {
                      return const WalletWidget();
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              ),
            ),
          ),
        ),
       Obx(()=> AppButton(
         text: controller.getButtonText(),
         onClick: controller.onProceed,
       ))
      ],
    );
  }

  _buildTopSection() {

    return Row(
      children: [
        const AppCircleAssetPng("assets/image/lic.png",innerPadding: 12,size: 60,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LIC Premium",
                style: Get.textTheme.subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() =>
                  (controller.actionType.value == LicOnlineActionType.payBill)
                      ? Text(
                          controller.billInfoResponse.billInfo.toString(),
                          style: Get.textTheme.bodyText1?.copyWith(),
                        )
                      : const SizedBox()),
            ],
          ),
        ),
      ],
    );
  }

  _buildFormKey() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTopSection(),
            Obx(() =>
                controller.actionType.value == LicOnlineActionType.payBill
                    ? _buildInformationDetailWidget()
                    : const SizedBox()),
            Form(
              key: controller.billFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(()=>AppTextField(
                      enable: controller.isFieldEnable(),
                      inputType: TextInputType.text,
                      allCaps: true,
                      maxLength: 20,
                      validator: (value) =>
                          FormValidatorHelper.normalValidation(value, minLength: 6),
                      hint: "Enter Policy Number",
                      label: "Policy Number",
                      controller: controller.policyNumberController)),
                  Obx(()=>MobileTextField(
                  enable: controller.isFieldEnable(),
                  controller: controller.mobileNumberController)),

                  Obx(()=>DobTextField(
                      enable: controller.isFieldEnable(),
                      controller: controller.dobController)),

                  Obx(()=>EmailTextField(
                      enable: controller.isFieldEnable(),
                      controller: controller.emailController)),
                  Obx(() => (controller.actionType.value == LicOnlineActionType.payBill)
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: AmountBackgroundWidget(
                                  child: AmountTextField(
                                      enable:
                                          controller.isAmountEnable() ?? true,
                                      focus: true,
                                      validator: (value) =>
                                          FormValidatorHelper.amount(value,
                                              minAmount: 100,
                                              maxAmount: 200000),
                                      controller: controller.amountController)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            AmountBackgroundWidget(
                                child: MPinTextField(
                                    focus: true,
                                    controller: controller.mpinController))
                          ],
                        )
                      : const SizedBox())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildInformationDetailWidget() {
    var name = controller.billInfoResponse.name ?? "";
    var amount = controller.billInfoResponse.amount ?? "";
    var dueDate = controller.billInfoResponse.dueDate ?? "";
    var billDate = controller.billInfoResponse.dueDate ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBillInformationTitleWidget(),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(top: 0, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBillInfoItem("Consumer Name", name),
              _buildBillInfoItem("Amount", amount),
              _buildBillInfoItem("Bill Date", billDate),
              _buildBillInfoItem("Due Date", dueDate, color: Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  _buildBillInfoItem(String title, String value,
      {Color color = Colors.black54}) {
    if (value.isEmpty || value == "null" || value == "Null") {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Get.textTheme.subtitle2?.copyWith(color: Colors.black54),
            ),
            flex: 2,
          ),
          const Text(" : "),
          Expanded(
            child: Text(
              value,
              style: Get.textTheme.subtitle2?.copyWith(color: color),
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }

  Padding _buildBillInformationTitleWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "Bill Information",
        style: Get.textTheme.subtitle1,
      ),
    );
  }
}
