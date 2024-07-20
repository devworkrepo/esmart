import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:esmartbazaar/page/credit_card/credit_card_controller.dart';

import '../../../widget/text_field.dart';
import '../../../util/validator.dart';

class CardInfoWidget extends GetView<CreditCardController> {
  const CardInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16,),
        Text(
          "Bill Information",
          style:
              Get.textTheme.subtitle1?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Get.theme.primaryColorDark
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildTitle("Per Transaction Limit"),
                      _buildTitle("Monthly Transaction Limit"),
                      _buildTitle("Your Available Limit")
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTitle("₹ ${controller.creditCardLimitResponse.perTransaction}"),
                      _buildTitle("₹ ${controller.creditCardLimitResponse.monthlyLimit}"),
                      _buildTitle("₹ ${controller.creditCardLimitResponse.availLimit}"),
                    ],
                  ),
                )
              ],
            )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        AmountBackgroundWidget(
            child: Column(children: [
              AmountTextField(
                  label: "Bill Amount",
                  validator: (value) => FormValidatorHelper.amount(value,minAmount: 10,maxAmount: 49999),
                  controller: controller.amountController),
              MPinTextField(controller: controller.mpinController)
            ],)),
      ],
    );
  }

  _buildTitle(
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        title,
        style: Get.textTheme.subtitle1?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }
}
