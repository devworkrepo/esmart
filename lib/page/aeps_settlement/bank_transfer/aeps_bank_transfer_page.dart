import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/radio.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../widget/drop_down.dart';
import 'aeps_bank_transfer_controller.dart';

class AepsBankTransferPage extends GetView<AepsBankTransferController> {
  const AepsBankTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsBankTransferController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Settlement"),
      ),
      body: ObsResourceWidget(
          obs: controller.calcObs,
          childBuilder: (data) => SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildAmountWidget(),
                        ),
                      ),
                    ),
                    _buildBankAccountWidget(),
                  ],
                ),
              )),
    );
  }

  Widget _buildBankAccountWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8,left: 8,right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formBankAccount,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settlement Bank Account",style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 12,),
                    BuildTitleValueWidget(
                        title: "Account Name",
                        value: controller.bank.accountName.toString()),
                    BuildTitleValueWidget(
                        title: "Account No",
                        value: controller.bank.accountNumber.toString()),
                    BuildTitleValueWidget(
                        title: "IFSC Code",
                        value: controller.bank.ifscCode.toString()),
                    BuildTitleValueWidget(
                        title: "Bank Name",
                        value: controller.bank.bankName.toString())
                  ],
                ),
              //  _buildAmountWidget(),
                AppTextField(
                  controller: controller.remarkController,
                  label: "Remark",
                  hint: "Optional",
                ),
                MPinTextField(controller: controller.mpinController),
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

  Widget _buildAmountWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Aeps Balance",
          style: Get.textTheme.bodyText1?.copyWith(color: Colors.grey),
        ),
        Text(
          "₹ ${controller.aepsBalance.toString()}",
          style: Get.textTheme.headline3?.copyWith(color: Colors.green),
        ),
        SizedBox(
          height: 12,
        ),
        _BuildVerticalTitleValue(
            title: "Transfer Amount",
            value: "₹ " + controller.bank.transferAmount.value.toString()),
        _BuildVerticalTitleValue(
            title: "Transaction Charge",
            value: "₹ " + controller.calcResponse.charges.toString()),
      ],
    );
  }
}

class _BuildVerticalTitleValue extends StatelessWidget {
  final String title;
  final String value;

  const _BuildVerticalTitleValue(
      {required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey[600]),
        ),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.blue[600]),
        ),
        Divider(
          indent: 0,
        ),
      ],
    );
  }
}
