import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/recharge/extram_param.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/recharge/bill_payment/bill_payment_controller.dart';
import 'package:esmartbazaar/page/recharge/provider/provider_controller.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:esmartbazaar/widget/common/wallet_widget.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class BillPaymentPage extends GetView<BillPaymentController> {
  const BillPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BillPaymentController());
    return Scaffold(
      appBar: AppBar(
        title: Text((controller.isPartBillPayment)
            ? "Part Bill Pay"
            : controller.providerName + " Bill Pay"),
      ),
      body: ObsResourceWidget(
        obs: controller.extraParamResponseObs,
        childBuilder: (data) => _buildBody(),
      ) /*Obx(
          () => controller.extraParamResponseObs.value.when(onSuccess: (data) {
                return _buildBody(data);
              }, onFailure: ( e) {
                return ExceptionPage(error: e);
              }, onInit: (data) {
                return AppProgressbar(
                  data: data,
                );
              }))*/
      ,
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
                  _buildFormKey(controller.extraParamResponse),
                  Obx(() {
                    if (controller.actionType.value ==
                        BillPaymentActionType.payBill) {
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
        AppButton(
          text: controller.getButtonText(),
          onClick: controller.onProceed,
        )
      ],
    );
  }

  _buildTopSection() {
    var imageName = getProviderInfo(controller.providerType)!.imageName;
    return Row(
      children: [
        AppCircleAssetSvg("assets/svg/$imageName.svg"),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.provider.name,
                style: Get.textTheme.subtitle1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() =>
                  (controller.actionType.value == BillPaymentActionType.payBill)
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

  _buildFormKey(BillExtraParamResponse data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTopSection(),
            Obx(() =>
                controller.actionType.value == BillPaymentActionType.payBill
                    ? _buildInformationDetailWidget()
                    : const SizedBox()),
            Form(
              key: controller.billFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildField1(),
                  MobileTextField(
                      enable: controller.isFieldEnable(),
                      controller: controller.mobileNumberController),
                  (controller.extraParamResponse.field2!.isNotEmpty)
                      ? (controller.providerType == ProviderType.insurance)
                          ? DobTextField(
                              enable: controller.isFieldEnable(),
                              controller: controller.fieldTwoController)
                          : _buildField2()
                      : const SizedBox(),
                  (controller.extraParamResponse.field3!.isNotEmpty)
                      ? (controller.providerType == ProviderType.insurance)
                          ? EmailTextField(
                              enable: controller.isFieldEnable(),
                              controller: controller.fieldThreeController)
                          : _buildField3()
                      : const SizedBox(),
                  Obx(() => (controller.actionType.value ==
                          BillPaymentActionType.payBill)
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: AmountBackgroundWidget(
                                  child: AppTextField(
                                    label: "Amount",
                                     hint:  "Enter amount",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,
                                      enable: controller.isAmountEnable(),
                                      inputType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      focus: true,
                                      validator: (value) =>
                                          FormValidatorHelper.amount(value,
                                              minAmount: 100,
                                              maxAmount: 500000),
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

  AppTextField _buildField1() {
    return AppTextField(
        enable: controller.isFieldEnable(),
        inputType: TextInputType.text,
        allCaps: true,
        maxLength: 20,
        validator: (value) =>
            FormValidatorHelper.normalValidation(value, minLength: 6),
        hint: "Enter ${controller.extraParamResponse.field1}",
        label: controller.extraParamResponse.field1,
        controller: controller.fieldOneController);
  }

  AppTextField _buildField3() {
    return AppTextField(
        enable: controller.isFieldEnable(),
        inputType: TextInputType.text,
        allCaps: true,
        validator: FormValidatorHelper.normalValidation,
        maxLength: 20,
        hint: "Enter ${controller.extraParamResponse.field3}",
        label: controller.extraParamResponse.field3,
        controller: controller.fieldThreeController);
  }

  AppTextField _buildField2() {
    return AppTextField(
        enable: controller.isFieldEnable(),
        inputType: TextInputType.text,
        allCaps: true,
        maxLength: 20,
        validator: FormValidatorHelper.normalValidation,
        hint: "Enter ${controller.extraParamResponse.field2}",
        label: controller.extraParamResponse.field2,
        controller: controller.fieldTwoController);
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
