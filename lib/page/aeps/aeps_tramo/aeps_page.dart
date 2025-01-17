import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/radio.dart';
import 'package:esmartbazaar/widget/status_bar_color_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/input_validator.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../transaction_type.dart';
import 'aeps_controller.dart';

class AepsPage extends GetView<AepsController> {
  const AepsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsController());
    return StatusBarColorWidget(
      color: Get.theme.primaryColorDark,
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.getTitle()),
        ),
        body: ObsResourceWidget(
          obs: controller.aepsBankListResponseObs,
          childBuilder: (data) => _buildBody(),
        ),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (!controller.requireAuth.value)
                    ? _buildFormKeyOne()
                    : _buildF2FWidget()
              ],
            ),
          ),
        ),
        AppButton(
          text: "Capture and Proceed",
          onClick: controller.onProceed,
        )
      ],
    );
  }

  _buildF2FWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Image.asset("assets/image/aeps.png"),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2FA Authentication",
                              style: Get.textTheme.headline2
                                  ?.copyWith(color: Colors.white),
                            ),
                            Text(
                              "Just 2fa yourself to use aeps withdraw services.",
                              style: Get.textTheme.subtitle1
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
                color: Get.theme.primaryColorDark,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 24, right: 24, left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Select Bank and proceed",
                      style: TextStyle(
                        color: Get.theme.primaryColorDark,
                        fontSize: 18
                      ),),

                      const SizedBox(height: 5,),

                      Text("This process need to do once in a day",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14
                        ),),

                      const SizedBox(height: 16,),

                      AppDropDown(
                        maxHeight: Get.height * 0.75,
                        list:
                            List.from(controller.bankList.map((e) => e.name)),
                        selectedItem: (controller.selectedAepsBank == null)
                            ? null
                            : controller.selectedAepsBank!.name!,
                        onChange: (value) {
                          try {
                            controller.selectedAepsBank = controller.bankList
                                .firstWhere(
                                    (element) => element.name == value);
                          } catch (e) {
                            controller.selectedAepsBank = null;
                            Get.snackbar("Bank is not selected",
                                "Exception raised while selecting bank",
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          }
                        },
                        validator: (value) {
                          if (controller.selectedAepsBank == null) {
                            return "Select bank";
                          } else {
                            return null;
                          }
                        },
                        searchMode: true,
                        label: "Select Bank",
                        hint: "Select Bank",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildFormKeyOne() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: controller.aepsFormKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 24, right: 24, left: 24),
                    child: Column(
                      children: [
                        AppTextField(
                            inputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              AadhaarInputValidator()
                            ],
                            maxLength: 14,
                            hint: "Aadhaar number",
                            label: "Aadhaar Number",
                            validator: (value) {
                              if (value!.length == 14) {
                                return null;
                              } else {
                                return "Enter 12 digits aadhaar number";
                              }
                            },
                            controller: controller.aadhaarNumberController),
                        MobileTextField(
                            controller: controller.mobileController),
                        AppDropDown(
                          maxHeight: Get.height * 0.75,
                          list:
                              List.from(controller.bankList.map((e) => e.name)),
                          selectedItem: (controller.selectedAepsBank == null)
                              ? null
                              : controller.selectedAepsBank!.name!,
                          onChange: (value) {
                            try {
                              controller.selectedAepsBank = controller.bankList
                                  .firstWhere(
                                      (element) => element.name == value);
                            } catch (e) {
                              controller.selectedAepsBank = null;
                              Get.snackbar("Bank is not selected",
                                  "Exception raised while selecting bank",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                          },
                          validator: (value) {
                            if (controller.selectedAepsBank == null) {
                              return "Select bank";
                            } else {
                              return null;
                            }
                          },
                          searchMode: true,
                          label: "Select Bank",
                          hint: "Select Bank",
                        ),
                      ],
                    ),
                  ),
                ),
                (controller.isAadhaarPay)
                    ? SizedBox()
                    : Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16, right: 16, left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transaction Type",
                                style: Get.textTheme.subtitle1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              AppRadioButton<AepsTransactionType>(
                                groupValue:
                                    controller.aepsTransactionType.value,
                                value: AepsTransactionType.cashWithdrawal,
                                title: "Cash Withdrawal",
                                onChange: (AepsTransactionType type) {
                                  controller.aepsTransactionType.value = type;
                                },
                              ),
                              AppRadioButton<AepsTransactionType>(
                                groupValue:
                                    controller.aepsTransactionType.value,
                                value: AepsTransactionType.balanceEnquiry,
                                title: "Balance Enquiry",
                                onChange: (AepsTransactionType type) {
                                  controller.aepsTransactionType.value = type;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                Obx(() => (controller.aepsTransactionType.value ==
                            AepsTransactionType.cashWithdrawal ||
                        controller.isAadhaarPay)
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16, right: 16, left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transaction Amount",
                                style: Get.textTheme.subtitle1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              AmountTextField(
                                controller: controller.amountController,
                                validator: (value) =>
                                    FormValidatorHelper.amount(value,
                                        minAmount: 100, maxAmount: 10000),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
