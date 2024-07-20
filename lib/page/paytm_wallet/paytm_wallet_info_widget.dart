import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:esmartbazaar/page/credit_card/credit_card_controller.dart';
import 'package:esmartbazaar/page/paytm_wallet/paytm_wallet_controller.dart';

import '../../../widget/text_field.dart';
import '../../../util/validator.dart';

class PaytmWalletInfoWidget extends GetView<PaytmWalletController> {
  const PaytmWalletInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16,),
        Text(
          "Paytm Wallet Info",
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
                      _buildTitle("Kyc Limit"),
                      _buildTitle("Non-Kyc Limit"),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTitle("₹ 1,00,000"),
                      _buildTitle("₹ 10,000"),
                    ],
                  ),
                )
              ],
            )
              ],
            ),
          ),
        ),
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
