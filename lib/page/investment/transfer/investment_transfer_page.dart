import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/investment/Investment_close_calc.dart';
import 'package:esmartbazaar/page/investment/transfer/investment_transfer_controller.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/text_field.dart';

class InvestmentTransferPage extends GetView<InvestmentTransferController> {
  const InvestmentTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentTransferController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Investment Transfer"),
      ),
      body: ObsResourceWidget<InvestmentCloseCalcResponse>(
          obs: controller.calcObs,
          childBuilder: (data) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildBankDetailWidget(),
                    _buildAmountChargeWidget(data),
                    _buildInputDetail(data),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.onSubmit();
                            },
                            child: Text("Confirm And Transfer")))
                  ],
                ),
              ),
            );
          }),
    );
  }

  Card _buildBankDetailWidget() {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Bank Details",
                    style: Get.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.account_balance)
                ],
              ),
              SizedBox(
                height: 16,
              ),
              _BuildSubItem(
                  title: "Name", value: controller.bank.accountName.toString()),
              _BuildSubItem(
                  title: "Bank Name",
                  value: controller.bank.bankName.toString()),
              _BuildSubItem(
                  title: "Bank Account",
                  value: controller.bank.accountNumber.toString()),
              _BuildSubItem(
                  title: "Bank IFSC",
                  value: controller.bank.ifscCode.toString())
            ],
          ),
        ),
      ),
    );
  }

  Card _buildAmountChargeWidget(InvestmentCloseCalcResponse data) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Amount Details",
                    style: Get.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.money)
                ],
              ),
              SizedBox(
                height: 16,
              ),
              _BuildSubItem(
                  title: "Amount",
                  value: AppConstant.rupeeSymbol + data.balance.toString()),
              _BuildSubItem(
                  title: "Charge",
                  value: AppConstant.rupeeSymbol + data.charges.toString()),
              _BuildSubItem(
                  title: "Close Type", value: data.closetype.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildInputDetail(InvestmentCloseCalcResponse data) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Fill Input",
                      style: Get.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.input)
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                MPinTextField(controller: controller.mpinController),
                AppTextField(
                    label: "Remark", controller: controller.remarkController,
                validator: FormValidatorHelper.empty,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildSubItem extends StatelessWidget {
  final String title;
  final String value;

  const _BuildSubItem({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Text("  :  "),
        Expanded(
          child: Text(
            value,
            style: Get.textTheme.caption
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
