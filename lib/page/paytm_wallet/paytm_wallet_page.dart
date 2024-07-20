import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/paytm_wallet/paytm_wallet_controller.dart';
import 'package:esmartbazaar/page/paytm_wallet/paytm_wallet_info_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

class PaytmWalletPage extends GetView<PaytmWalletController> {
  const PaytmWalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaytmWalletController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Paytm Wallet Load"),
      ),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSearchSenderForm(),
                  Obx(() => (controller.actionType.value ==
                          PaytmWalletLoadActionType.transaction)
                      ? _buildTransactionForm()
                      : const SizedBox()),
                ],
              ),
            )),
            Obx(() => controller.actionType.value ==
                    PaytmWalletLoadActionType.transaction
                ? AppButton(
                    text: "Proceed",
                    onClick: () => controller.onProceed())
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  _buildSearchSenderForm() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Paytm Wallet Number", style: Get.textTheme.headline6),
              const SizedBox(
                height: 8,
              ),
              Obx(() => MobileTextField(
                    controller: controller.mobileController,
                    enable: controller.actionType.value ==
                        PaytmWalletLoadActionType.verify,
                  )),
              Obx(() => controller.actionType.value ==
                      PaytmWalletLoadActionType.verify
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Note: Rs 1 will be duducted for Paytm Wallet Verification.",
                        style: Get.textTheme.subtitle2?.copyWith(color: Colors.grey[700]),
                      ),
                    )
                  : const SizedBox()),
              Obx(() => (controller.actionType.value ==
                      PaytmWalletLoadActionType.verify)
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        AppButton(
                            text: "Verify & Next",
                            onClick: () => controller.verify()),
                        const SizedBox(
                          height: 16,
                        ),
                        AppButton(
                          text: "Continue Without Verify",
                          onClick: () => controller.withoutVerify(),
                          background: Colors.yellow[800],
                        )
                      ],
                    )
                  : const SizedBox()),
              Obx(() => (controller.actionType.value ==
                      PaytmWalletLoadActionType.transaction)
                  ? const PaytmWalletInfoWidget()
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  _buildTransactionForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Load Wallet Form", style: Get.textTheme.headline6),
              const SizedBox(
                height: 12,
              ),
              AppTextField(
                controller: controller.nameController,
                label: "Customer Name",
                validator: FormValidatorHelper.normalValidation,
              ),
              AmountTextField(
                controller: controller.amountController,
                validator: (value) => FormValidatorHelper.amount(value,
                    minAmount: 100, maxAmount: 5000),
              ),
              MPinTextField(controller: controller.mpinController)
            ],
          ),
        ),
      ),
    );
  }
}
