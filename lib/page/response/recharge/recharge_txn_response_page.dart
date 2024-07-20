import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/transaction_page.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';

import 'recharge_txn_response_controller.dart';

// ignore: must_be_immutable
class RechargeTxnResponsePage extends GetView<RechargeTxnResponseController>
    with TransactionPageComponent {
  RechargeTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(
              controller.response.transactionStatus ?? "Pending")),
          buildStatusTitle(
              getStatusIdFromString(
                  controller.response.transactionStatus ?? "Pending"),
              statusDescription: controller.response.transactionStatus),
          buildMessage(controller.response.transactionResponse ?? ""),
          buildTransactionTime(""),
          buildProviderAndAmount(
              title: controller.response.rechargeType ?? "",
              subTitle: controller.getTitle(),
              amount: controller.response.amount,
              imageSvgPath: (controller.provider != ProviderType.ott)
                  ? controller.getSvgImage()
                  : null,
              imagePath: (controller.provider == ProviderType.ott)
                  ? "assets/image/ott.png"
                  : null),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Mobile Number",
                value: controller.response.mobileNumber ?? ""),
           if((controller.response.customerId ?? "").isNotEmpty) buildTitleValueWidget(
                title: "Customer Id",
                value: controller.response.customerId ?? ""),
            buildTitleValueWidget(
                title: "Operator Name",
                value: controller.response.operatorName ?? ""),
            buildTitleValueWidget(
                title: "Operator Ref No.",
                value: controller.response.operatorRefNumber ?? ""),
            buildTitleValueWidget(
                title: "Transaction No.",
                value: controller.response.transactionNumber ?? ""),
          ], topBottom: true),

          appLogo(),
        ],
      ),
      status: getStatusIdFromString(controller.response.transactionStatus ?? "Pending"),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}
