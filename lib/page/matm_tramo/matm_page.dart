import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/radio.dart';
import 'package:esmartbazaar/widget/status_bar_color_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';

import 'matm_controller.dart';

class MatmTramoPage extends GetView<MatmTramoController> {
  const MatmTramoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmTramoController());
    return StatusBarColorWidget(
      color: Get.theme.primaryColorDark,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Matm"),
        ),
        body: ObsResourceWidget(
            obs: controller.aepsBankListResponseObs,
            childBuilder: (data) => _buildBody()),
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
              children: [_buildFormKeyOne()],
            ),
          ),
        ),
        AppButton(
          text: "Proceed",
          onClick: controller.onProceed,
        )
      ],
    );
  }

  _buildFormKeyOne() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: controller.matmFormKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 24, right: 24, left: 24),
                    child: Column(
                      children: [
                        MobileTextField(
                            controller: controller.mobileController),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, bottom: 16, right: 16, left: 16),
                    child: Obx(()=>Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transaction Type",
                          style: Get.textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        AppRadioButton<MatmTramoTransactionType>(
                          groupValue: controller.transactionType.value,
                          value: MatmTramoTransactionType.cashWithdrawal,
                          title: "Cash Withdrawal",
                          onChange: (MatmTramoTransactionType type) {
                            controller.transactionType.value = type;
                          },
                        ),
                        AppRadioButton<MatmTramoTransactionType>(
                          groupValue: controller.transactionType.value,
                          value: MatmTramoTransactionType.balanceEnquiry,
                          title: "Balance Enquiry",
                          onChange: (MatmTramoTransactionType type) {
                            controller.transactionType.value = type;
                          },
                        ),
                      ],
                    )),
                  ),
                ),
                Obx(() => (controller.transactionType.value ==
                        MatmTramoTransactionType.cashWithdrawal)
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
                                        minAmount: (kDebugMode ||
                                                controller.appPreference
                                                        .mobileNumber ==
                                                    "7982607742")
                                            ? 1
                                            : 100,
                                        maxAmount: 10000),
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

enum MatmTramoTransactionType {
  cashWithdrawal,
  balanceEnquiry,
}
