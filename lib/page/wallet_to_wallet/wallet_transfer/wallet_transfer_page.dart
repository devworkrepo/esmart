import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/check_box.dart';
import 'package:esmartbazaar/widget/common/wallet_widget.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/wallet_to_wallet/wallet_transfer/wallet_transfer_controller.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/validator.dart';

class WalletTransferPage extends GetView<WalletTransferController> {
  const WalletTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WalletTransferController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Transfer"),
      ),
      body: Column(children: [
        Expanded(child:
        SingleChildScrollView(
          child: Column(
            children: [
              _BuildHeaderWidget(),
              _BuildForm(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WalletWidget(),
              )
            ],
          ),
        ),),
        AppButton(
          text: "Proceed",
          onClick: controller.onProceed,
        )
      ],),
    );
  }
}

class _BuildForm extends GetView<WalletTransferController> {
  const _BuildForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                AmountTextField(controller: controller.amountController),
                AppTextField(
                  controller: controller.remarkController,
                  label: "Remark",
                  hint: "Optional",
                ),
                MPinTextField(
                  controller: controller.mpinController,
                ),
                Obx(() => AppCheckBox(
                    value: controller.isFavouriteChecked.value,
                    onChange: (value) {
                      controller.isFavouriteChecked.value = value;
                    },
                    title: "Add to Favourite"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildHeaderWidget extends GetView<WalletTransferController> {
  const _BuildHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = controller.data;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Get.theme.primaryColorDark,
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                AppCircleNetworkImage(
                  AppConstant.profileBaseUrl + data.picName!,
                  size: 70,
                ),
                Column(
                  children: [
                    Text(
                      data.agentName!,
                      style: Get.textTheme.headline6
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      data.mobileNumber!,
                      style: Get.textTheme.headline6
                          ?.copyWith(color: Colors.white70),
                    ),
                    Text(
                      "( ${data.outletName!} )",
                      style: Get.textTheme.bodyText1
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
