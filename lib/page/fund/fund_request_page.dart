import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/fund/fund_request_controller.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../util/input_validator.dart';
import '../../util/obx_widget.dart';

class FundRequestPage extends GetView<FundRequestController> {
  const FundRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FundRequestController());
    return Scaffold(
      appBar: _buildAppbar(),
      body: ObsResourceWidget(
          obs: controller.bankTypeResponseObs,
          childBuilder: (data) => _buildBody()),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: const [
                FundRequestFormField(),
              ],
            ),
          )),
          Obx(() => AppButton(
              text: (controller.updateDetail != null)
                  ? "Update Request" +((controller.paymentTypeObs.value.isNotEmpty) ? "" : "")
                  : "Make Request" +
                      (controller.paymentTypeObs.value.isNotEmpty ? "" : ""),
              onClick: () => controller.onFundRequestSubmitButtonClick()))
        ],
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title:  Text("Fund Request ${(controller.updateDetail != null) ? "Update" : ""}"),
    );
  }
}

class FundRequestFormField extends GetView<FundRequestController> {
  const FundRequestFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fundRequestFormKey,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Obx(() => AppDropDown(
                        list: controller.typeList.map((e) => e.name!).toList(),
                        onChange: (value) {
                          controller.paymentTypeObs.value = value;
                        },
                        selectedItem:
                            (controller.paymentTypeObs.value.isNotEmpty)
                                ? controller.paymentTypeObs.value
                                : null,
                        label: "Payment Type",
                      )),
                  Obx(() => AppDropDown(
                        list:
                            controller.accountList.map((e) => e.name!).toList(),
                        onChange: (value) {
                          controller.paymentAccountObs.value = value;
                        },
                        selectedItem:
                            (controller.paymentTypeObs.value.isNotEmpty)
                                ? controller.paymentAccountObs.value
                                : null,
                        label: "Payment Account",
                      )),
                  AppTextField(
                    controller: controller.paymentDateController,
                    label: "Payment Date",
                    hint: "Required*",
                    onFieldTab: () {
                      DateUtil.showDatePickerDialog((dateTime) {
                        controller.paymentDateController.text = dateTime;
                      });
                    },
                  ),
                ],
              ),
          ),
        ),


        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  AppTextField(
                    controller: controller.uploadSlipController,
                    prefixIcon: Icons.file_copy_outlined,
                    label: "Upload Slip",
                    hint: "",
                    onFieldTab: () =>
                        controller.showImagePickerBottomSheetDialog(),
                  ),
                AppTextField(controller: controller.remarkController,
                  label: "Remark",
                  hint: "Optional",),

                AppTextField(controller: controller.amountController,
                  label: "Amount",
                  hint: "Enter Amount",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  inputType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) =>
                      FormValidatorHelper.amount(value,
                          minAmount: 1, maxAmount: 10000000),

                ),
              ],
            ),
          ),
        )
      ],),
    );
  }
}
