import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/radio.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../widget/drop_down.dart';
import 'settlement_controller.dart';

class AepsSettlementPage extends GetView<AepsSettlementController> {
  const AepsSettlementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsSettlementController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Settlement"),
      ),
      body: ObsResourceWidget(
          obs: controller.balanceResponseObs,
          childBuilder: (data) => SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTransferToWidget(),
                    Column(
                      children: [
                        (controller.actionType ==
                                AepsSettlementType.spayAccount)
                            ? _buildSpayAccountWidget()
                            : _buildBankAccountWidget(),
                      ],
                    )
                  ],
                ),
              )),
    );
  }

  Padding _buildSpayAccountWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formSpayAccount,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountWidget(),
                AmountTextField(controller: controller.amountController),
                AppTextField(
                  controller: controller.remarkController,
                  hint: "Optional",
                  label: "Remark",
                ),
                const SizedBox(
                  height: 16,
                ),
                AppButton(
                    text: "Proceed",
                    onClick: () => controller.onSpayAccountSettlement())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankAccountWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formBankAccount,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountWidget(),
                AmountTextField(controller: controller.amountController),
                AppTextField(
                  controller: controller.remarkController,
                  label: "Remark",
                  hint: "Optional",
                ),
                const SizedBox(
                  height: 16,
                ),
                AppButton(
                    text: "Proceed",
                    onClick: () => controller.onBankSettlement())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildTransferToWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transfer Balance To",
                  style: Get.textTheme.subtitle1,
                ),
                SizedBox(height: 5,),
                Text(
                  (controller.actionType == AepsSettlementType.spayAccount)
                      ? "Smart Wallet"
                      : "Bank Account",
                  style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
                ),

                if(controller.settlementBank != null) Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person,color: Colors.blue[900],),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        (controller.settlementBank!.accountName ?? "NA"),
                                        style: Get.textTheme.subtitle1
                                            ?.copyWith(color: Colors.blue[900]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.account_balance),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.settlementBank!.accountNumber ?? "NA",
                                            style: Get.textTheme.subtitle1,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            (controller.settlementBank!.bankName ?? "NA"),
                                            style: Get.textTheme.subtitle2
                                                ?.copyWith(
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(height: 3,),
                                          Text(
                                            (controller.settlementBank!.ifscCode ?? "NA"),
                                            style: Get.textTheme.subtitle2
                                                ?.copyWith(
                                                color: Colors.grey[600]),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Aeps Balance",
          style: Get.textTheme.bodyText1?.copyWith(color: Colors.grey),
        ),
        Text(
          "₹ ${controller.aepsBalance!.balance.toString()}",
          style: Get.textTheme.headline3?.copyWith(color: Colors.green),
        )
      ],
    );
  }
}
