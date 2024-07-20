import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

import '../text_field.dart';

class AmountConfirmDialogWidget extends StatefulWidget {
  final Function onConfirm;
  final String? amount;
  final bool isDecimal;
  final String title;
  final String? description;
  final List<ListTitleValue>? detailWidget;

  const AmountConfirmDialogWidget(
      {required this.onConfirm,
      this.amount,
      this.isDecimal = false,
      this.title = "Confirm Transaction ?",
      this.detailWidget,
      Key? key,
      this.description})
      : super(key: key);

  @override
  _AmountConfirmDialogWidgetState createState() =>
      _AmountConfirmDialogWidgetState();
}

class _AmountConfirmDialogWidgetState extends State<AmountConfirmDialogWidget>
    with TransactionHelperMixin {
  var amountController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialogContainer(
      backPress: true,
      padding: 30,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            _buildCrossButton(),
            SizedBox(
              width: Get.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitleWidget(),
                  _buildDescription(),
                  _buildAmountTextWidget(),
                  SizedBox(height: 16,),
                  _buildDetailWidgets(),
                  // _buildAmountWidget(),
                  SizedBox(
                    height: 16,
                  ),
                  _buildConfirmButtonWidget()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildDescription() {
    if(widget.description == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(widget.description!,style: Get.textTheme.subtitle1,),
    );
  }

  _buildAmountTextWidget() {


    if (widget.amount == null) return const SizedBox();
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),



        Text(
          (widget.amount!.contains("₹") ? widget.amount! : "₹ "+widget.amount!),
          style: Get.textTheme.headline1
              ?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _buildDetailWidgets() {
    if (widget.detailWidget == null) {
      return const SizedBox();
    }

    return AmountBackgroundWidget(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            ...widget.detailWidget!.map((e) => Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(
                              e.title,
                              style: Get.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w500),
                            )),
                        const BuildDotWidget(),
                        Expanded(
                            flex: 5,
                            child: Text(
                              e.value,
                              style: Get.textTheme.subtitle2
                                  ?.copyWith(fontWeight: FontWeight.w500,color: Get.theme.primaryColor),
                            )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  _buildConfirmButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,bottom: 8),
      child: SizedBox(
        width: 200,
        child: AppButton(
          isRounded: true,
            text: "Confirm & Proceed",
            onClick: () {
              Get.back();
                  widget.onConfirm();
            }),
      ),
    );
  }

  _buildAmountWidget() {
    if (widget.amount == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: AmountTextField(
          controller: amountController,
          label: "Confirm Amount",
          hint: "Enter Confirm Amount",
          validator: (value) {
            if ("₹ " + value.toString() == widget.amount) {
              return null;
            } else {
              return "Amount didn't matched!";
            }
          },
        ),
      ),
    );
  }

  _buildTitleWidget() {
    return Text(
      widget.title,
      style: Get.textTheme.headline3,
    );
  }

  _buildCrossButton() {
    return Positioned(
        top: 0,
        right: 0,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.cancel,
            size: 32,
            color: Colors.grey,
          ),
        ));
  }
}
