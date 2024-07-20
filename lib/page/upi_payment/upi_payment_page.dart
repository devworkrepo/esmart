import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/upi_payment/upi_payment_controller.dart';

import '../../util/validator.dart';
import '../../widget/button.dart';
import '../../widget/text_field.dart';

class UpiPaymentPage extends GetView<UpiPaymentController> {
  const UpiPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiPaymentController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("UPI Payment"),
        ),
        body: _formWidget(),
      ),
    );
  }

  _formWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 24, right: 24, left: 24),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            "assets/image/upi_payment.png",
                            height: 70,
                            width: 70,
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "UPI Add Fund",
                                    style: Get.textTheme.headline6?.copyWith(
                                        color: Get.theme.primaryColorLight),
                                  ),
                                  SizedBox(height: 5,),
                                  Text("Credit your smart bazaar account wallet with upi payment")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AmountTextField(
                        controller: controller.amountController,
                        validator: (value) => FormValidatorHelper.amount(value,
                            minAmount: 1, maxAmount: 1000000),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      AppButton(
                          text: "Submit & Proceed",
                          onClick: controller.onSubmit)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
