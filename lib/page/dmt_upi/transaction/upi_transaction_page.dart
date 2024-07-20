import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/component/bank_detail_widget.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/component/dmt_calculate_charge.dart';
import 'package:esmartbazaar/page/dmt_upi/transaction/component/dmt_calculate_charge.dart';
import 'package:esmartbazaar/page/dmt_upi/transaction/upi_transaction_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/wallet_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';

import 'component/bank_detail_widget.dart';


class UpiTransactionPage extends GetView<UpiTransactionController> {
  const UpiTransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiTransactionController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upi Transaction"),
      ),
      body: ObsResourceWidget(
        obs: controller.calculateChargeResponseObs,
        childBuilder:(data)=> _buildBody(),
      )
      ,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      UpiTransactionBankDetailWidget(),
                      const _BuildTransactionAmountWidget(),
                      const _BuildMpinAndRemarkWidget(),
                    ],
                  ),
                  const UpiCalculateChargeWidget(),
                   const WalletWidget()
                ],
              ),
            ),
          ),
          AppButton(
            text: ("Proceed Transaction"),
            onClick: controller.onProceed,
          )
        ],
      ),
    );
  }
}

class _BuildTransactionAmountWidget extends GetView<UpiTransactionController> {
  const _BuildTransactionAmountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Amount",
                style:
                    Get.textTheme.subtitle1?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "₹ ${Get.arguments["amount"]}",
                style: Get.textTheme.headline2?.copyWith(color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  NumberToWord()
                          .convert(
                              "en-in", (int.parse(Get.arguments["amount"])))
                          .toUpperCase() +
                      " ONLY/-",
                  style:
                      Get.textTheme.bodyText1?.copyWith(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _BuildMpinAndRemarkWidget extends GetView<UpiTransactionController> {
  const _BuildMpinAndRemarkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transaction Pin",
                style:
                Get.textTheme.subtitle1?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 8,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: controller.remarkController,
                      label: "Remark",
                     hint: "Optional",
                    ),
                    MPinTextField(
                      controller: controller.mpinController,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

