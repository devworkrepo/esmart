import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';

import 'credit_card_txn_response_controller.dart';

// ignore: must_be_immutable
class CreditCardTxnResponsePage extends GetView<CreditCardTxnResponseController>
    with TransactionPageComponent {
  CreditCardTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreditCardTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(
              controller.response.transactionStatus ?? "InProgress")),
          buildStatusTitle(
            getStatusIdFromString(
                controller.response.transactionStatus ?? "InProgress"),
          ),
          buildMessage(controller.response.transactionResponse ?? "InProgress"),
          buildTransactionTime(controller.response.transactionDate),
          buildProviderAndAmount(
              title: controller.response.creditCardType ?? "N/A",
              subTitle: "Credit Card Payment",
              amount: controller.response.amount.toString(),
              imagePath: "assets/image/card.png"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Transaction No.",
                value: controller.response.transactionNumber ?? ""),
            buildTitleValueWidget(
                title: "Holder Name",
                value: controller.response.cardHolderName ?? ""),
            buildTitleValueWidget(
                title: "Card Number",
                value: controller.response.creditCardNumber ?? ""),
            buildTitleValueWidget(
                title: "Utr Number",
                value: controller.response.utrNumber ?? ""),
            buildTitleValueWidget(
                title: "Outlet Name",
                value: controller.response.outletName ?? ""),
            buildTitleValueWidget(
                title: "Outlet Number",
                value: controller.response.outletMobileNumber ?? ""),
          ], topBottom: true),
          appLogo(),
        ],
      ),
      status: getStatusIdFromString(
          controller.response.transactionStatus ?? "InProgress"),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}
