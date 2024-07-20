import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';

import 'ott_transaction_controller.dart';

class OttTransactionPage extends GetView<OttTransactionController> {
  const OttTransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OttTransactionController());
    return Scaffold(
      appBar: AppBar(title: const Text("OTT Subscription")),
      body: SingleChildScrollView(
        child: Column(
          children: const [_BuildHeaderSectionWidget(),_BuildFormWidget()],
        ),
      ),
    );
  }
}

class _BuildFormWidget extends GetView<OttTransactionController>{
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                MobileTextField(controller: controller.mobileController),
                EmailTextField(controller: controller.emailController),
                MPinTextField(controller: controller.mpinController),
                SizedBox(height: 24,),
                AppButton(text: "Proceed", onClick: controller.onProceed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _BuildHeaderSectionWidget extends GetView<OttTransactionController> {
  const _BuildHeaderSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Text(
                "Subscription Amount",
                style: Get.textTheme.headline6,
              ),
              Text(
                "₹ " + controller.plan.amount.toString(),
                style: Get.textTheme.headline1?.copyWith(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
              Text(
                NumberToWord().convert("en-in", int.parse(controller.plan.amount.toString())),
                style: Get.textTheme.subtitle1?.copyWith(
                    color: Colors.grey, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 12,),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Get.theme.primaryColorDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    BuildTitleValueWidget(title: "Subscription", value: controller.operator.operatorName.toString(),fontSize: 18,color: Colors.white,),
                    BuildTitleValueWidget(title: "Plan", value: controller.plan.code.toString(),fontSize: 18,color: Colors.white,),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
