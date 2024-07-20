import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/matm_credo/matm_credo_controller.dart';
import '../../util/validator.dart';
import '../../widget/button.dart';
import '../../widget/radio.dart';
import '../../widget/text_field.dart';

class MatmCredoPage extends GetView<MatmCredoController> {
  const MatmCredoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmCredoController());
    return Scaffold(
      appBar: AppBar(
        title: Text((controller.isMatm) ? "M-ATM" : "M-POS"),
      ),
      body: _buildBody(),
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
          onClick: () => controller.onProceed(),
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
            key: controller.formKey,
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
                    child: Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Transaction Type",
                              style: Get.textTheme.subtitle1,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            if (controller.isMatm)
                              AppRadioButton<MatmCredoTxnType>(
                                groupValue: controller.transactionTypeObs.value,
                                value: MatmCredoTxnType.microAtm,
                                title: "Cash Withdrawal",
                                onChange: (MatmCredoTxnType type) {
                                  controller.transactionTypeObs.value = type;
                                },
                              ),
                            if (controller.isMatm)
                              AppRadioButton<MatmCredoTxnType>(
                                groupValue: controller.transactionTypeObs.value,
                                value: MatmCredoTxnType.balanceEnquiry,
                                title: "Balance Enquiry",
                                onChange: (MatmCredoTxnType type) {
                                  controller.transactionTypeObs.value = type;
                                },
                              ),
                            if (!controller.isMatm)
                              AppRadioButton<MatmCredoTxnType>(
                                groupValue: controller.transactionTypeObs.value,
                                value: MatmCredoTxnType.mPos,
                                title: "M-POS Transaction",
                                onChange: (MatmCredoTxnType type) {
                                  controller.transactionTypeObs.value = type;
                                },
                              ),
                            if (!controller.isMatm)
                              AppRadioButton<MatmCredoTxnType>(
                                groupValue: controller.transactionTypeObs.value,
                                value: MatmCredoTxnType.voidTxn,
                                title: "Void Transaction",
                                onChange: (MatmCredoTxnType type) {
                                  controller.transactionTypeObs.value = type;
                                },
                              ),
                          ],
                        )),
                  ),
                ),
                Obx(() => (controller.transactionTypeObs.value ==
                            MatmCredoTxnType.microAtm ||
                        controller.transactionTypeObs.value ==
                            MatmCredoTxnType.mPos ||
                        controller.transactionTypeObs.value ==
                            MatmCredoTxnType.voidTxn)
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
                                        maxAmount: (controller.isMatm)
                                            ? 10000
                                            : 10000,
                                        multipleOf: (controller
                                                    .transactionTypeObs.value ==
                                                MatmCredoTxnType.mPos)
                                            ? null
                                            : 10),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(12),
                                width: Get.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Amount Hints",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    if (controller.transactionTypeObs.value ==
                                        MatmCredoTxnType.microAtm)  const Text(
                                        "Enter amount in multiple of 10."),

                                      Text(
                                          "Enter amount in range of 100 to ${controller.isMatm ? 10000 : 10000}"),
                                  ],
                                ),
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
