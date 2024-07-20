import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/component/bank_detail_widget.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/component/dmt_calculate_charge.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/dmt_transaction_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/wallet_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';

import '../dmt.dart';

class DmtTransactionPage extends GetView<DmtTransactionController> {
  const DmtTransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DmtTransactionController());
    return Scaffold(
      appBar: AppBar(
        title: Text(DmtHelper.getAppbarTitle(controller.dmtType)),
      ),
      body: ObsResourceWidget(
        obs: controller.calculateChargeResponseObs,
        childBuilder:(data)=> _buildBody(),
      ) /*Obx(() {
        return controller.calculateChargeResponseObs.value.when(
            onSuccess: (data) {
          if (data.code == 1) {
            return _buildBody();
          } else {
            return ExceptionPage(error: Exception(data.message));
          }
        }, onFailure: (e) {
          return ExceptionPage(error: e);
        }, onInit: (data) {
          return ApiProgress(data);
        });
      })*/
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
                      DmtTransactionBankDetailWidget(),
                      const _BuildTransactionAmountWidget(),
                      const _BuildMpinAndRemarkWidget(),
                    ],
                  ),
                  const DmtCalculateChargeWidget(),
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

class _BuildTransactionAmountWidget extends GetView<DmtTransactionController> {
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
                style: Get.textTheme.headline3?.copyWith(color: Colors.black),
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



class _BuildMpinAndRemarkWidget extends GetView<DmtTransactionController> {
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

