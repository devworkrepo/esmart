import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';

import 'paytm_wallet_txn_response_controller.dart';

// ignore: must_be_immutable
class PaytmWalletTxnResponsePage extends GetView<PaytmWalletTxnResponseController>
    with TransactionPageComponent {
  PaytmWalletTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaytmWalletTxnResponseController());

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
          buildTransactionTime(""),
          buildProviderAndAmount(
              title: controller.response.rechargeType ?? "N/A",
              subTitle: "Paytm Wallet Load",
              amount: controller.response.amount.toString(),
              imagePath: "assets/image/paytm.png"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Mobile Number",
                value: controller.response.mobileNumber ?? ""),
            buildTitleValueWidget(
                title: "Operator Name",
                value: controller.response.operatorName ?? ""),
            buildTitleValueWidget(
                title: "Operator Ref No",
                value: controller.response.operatorRefNumber ?? ""),
            buildTitleValueWidget(
                title: "Transaction No.",
                value: controller.response.transactionNumber ?? ""),
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
