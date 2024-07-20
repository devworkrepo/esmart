import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';

import '../../matm_tramo/matm_page.dart';
import 'matm_txn_response_controller.dart';

// ignore: must_be_immutable
class MatmTramoTxnResponsePage extends GetView<MatmTramoTxnResponseController>
    with TransactionPageComponent {
  MatmTramoTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmTramoTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(controller.response.statusId ?? 3),
          buildStatusTitle(controller.response.statusId ?? 3,
          ),
          buildMessage((controller.type == MatmTramoTransactionType.cashWithdrawal && controller.response.statusId ==3)
              ? "Transaction processing."
              : controller.response.message.toString()),
          buildTransactionTime(controller.response.time),
          buildProviderAndAmount(
              title: controller.getTxnType(),
              subTitle: "Micro Atm",
              amount: (controller.type == MatmTramoTransactionType.cashWithdrawal)
                  ? controller.response.transAmount.toString()
                  : null,
              imageSvgPath: "assets/svg/matm.svg"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Available Balance",
                value: controller.response.balAmount.toString()),
            buildTitleValueWidget(
                title: "Bank RRN", value: controller.response.bankRrn),
            buildTitleValueWidget(
                title: "Bank Name", value: controller.response.bankName),
            buildTitleValueWidget(
                title: "Card Number", value: controller.response.cardNumber),
            buildTitleValueWidget(
                title: "Message", value: controller.response.message),
          ], topBottom: true),
          if (controller.type == MatmTramoTransactionType.cashWithdrawal && controller.response.statusId == 3)
            Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Note : ",
                      style: Get.textTheme.subtitle1,
                    )),
                Text(
                  "Transaction is pending. Before initiating new transaction, kindly check the status of the your previous transaction by doing requery,",
                  style: TextStyle(color: Colors.yellow[900]),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          appLogo(),
        ],
      ),
      status: controller.response.statusId ?? 3,
      onShareClick: () => controller.captureAndShare(),
    );
  }
}
