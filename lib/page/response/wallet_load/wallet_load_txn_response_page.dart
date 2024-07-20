import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';

import 'wallet_load_txn_response_controller.dart';

// ignore: must_be_immutable
class WalletLoadTxnResponsePage extends GetView<WalletLoadTxnResponseController>
    with TransactionPageComponent {
  WalletLoadTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WalletLoadTxnResponseController());

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
              title: "",
              subTitle: "Smart Pay",
              amount: controller.response.amount.toString(),
              imagePath: "assets/image/wallet.png"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Transaction Number",
                value: controller.response.transactionNumber ?? ""),
            buildTitleValueWidget(
                title: "Agent Name",
                value: controller.response.agentName ?? ""),
            buildTitleValueWidget(
                title: "Outlet Name",
                value: controller.response.outletName ?? ""),


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
