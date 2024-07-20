import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';

import 'dmt_txn_response_controller.dart';

// ignore: must_be_immutable
class DmtTxnResponsePage extends GetView<DmtTxnResponseController>
    with TransactionPageComponent {
  DmtTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DmtTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(controller.getGlobalStatus())),
          buildStatusTitle(getStatusIdFromString(controller.getGlobalStatus()),
              statusDescription: controller.getGlobalStatus()),
          buildMessage(controller.dmtTransactionResponse.message),
          buildTransactionTime(""),
          buildProviderAndAmount(
              title: controller.dmtTransactionResponse.transactionType ?? "",
              subTitle: controller.getSubTitle(),
              amount: controller.totalAmount,
              imageSvgPath: "assets/svg/money.svg"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Name",
                value: controller.dmtTransactionResponse.beneficiaryName!),
            buildTitleValueWidget(
                title: "Account No. ",
                value: controller.dmtTransactionResponse.accountNumber!),
            buildTitleValueWidget(
                title: "Bank Name",
                value: controller.dmtTransactionResponse.bankName!),
            buildTitleValueWidget(
                title: "IFSC",
                value: controller.dmtTransactionResponse.ifscCode!),
          ], topBottom: true),
           Padding(
            padding: EdgeInsets.all(8.0),
            child: _BuildDetailsInfoWidget(),
          ),
          appLogo(),
        ],
      ),
      status: getStatusIdFromString(controller.getGlobalStatus()),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}

class _BuildDetailsInfoWidget extends GetView<DmtTxnResponseController> with TransactionPageComponent {
  _BuildDetailsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildHeadingsWidget(
                title: "Txn No.", alignment: Alignment.centerLeft),
            _buildHeadingsWidget(title: "Amount"),
            _buildHeadingsWidget(title: "Charge"),
            _buildHeadingsWidget(
                title: "Status", alignment: Alignment.centerRight),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        ...controller.dmtTransactionResponse.transactionList!.map(
          (e) => Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  _buildDetailsWidget(
                      title: e.transactionNumber ?? "",
                      widgetAlignment: Alignment.centerLeft),
                  _buildDetailsWidget(title: "₹ " + (e.amount ?? "")),
                  _buildDetailsWidget(title: "₹ " + (e.charge ?? "")),
                  _buildDetailsWidget(
                      title: e.transactionStatus ?? "Pending",
                      widgetAlignment: Alignment.centerRight,
                      textAlign: TextAlign.end,
                  color : getColor(getStatusIdFromString(e.transactionStatus ?? "pending"))),
                ],
              ),
              const Divider(
                indent: 0,
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildDetailsWidget(
      {required String title,
      Alignment widgetAlignment = Alignment.center,
      TextAlign textAlign = TextAlign.start,
      Color? color,
      int flex = 5}) {
    return Expanded(
        flex: flex,
        child: Align(
            alignment: widgetAlignment,
            child: Text(
              title,
              textAlign: textAlign,
              style: Get.textTheme.bodyText1?.copyWith(color: color ?? Colors.black54),
            )));
  }

  _buildHeadingsWidget(
      {required String title,
      Alignment alignment = Alignment.center,
      int flex = 5}) {
    return Expanded(
        flex: flex,
        child: Align(
            alignment: alignment,
            child: Text(
              title,
              style: Get.textTheme.subtitle1,
            )));
  }
}
