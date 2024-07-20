import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';


class DmtReceiptCommissionDialog extends StatefulWidget {
  final Function(int) onProceed;



  const DmtReceiptCommissionDialog(
      {required this.onProceed,
      Key? key,})
      : super(key: key);

  @override
  _DmtReceiptCommissionDialogState createState() =>
      _DmtReceiptCommissionDialogState();
}

class _DmtReceiptCommissionDialogState extends State<DmtReceiptCommissionDialog>
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
      padding: 20,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            _buildCrossButton(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleWidget(),
                _buildAmountWidget(),
                _buildConfirmButtonWidget()
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildAmountWidget() {

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Form(
        key: formKey,
        child: AmountTextField(
          controller: amountController,
          label: "Commission Amount",
          hint: "0.0",
          validator:(value)=>null,
        ),
      ),
    );
  }



  _buildConfirmButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: AppButton(
          text: "Proceed",
          onClick: () {
            int amount = 0;
            var strAmount = amountController.text.toString();
            if(strAmount.isNotEmpty){
              amount = int.parse(amountWithoutRupeeSymbol(amountController));
            }
            Get.back();
            widget.onProceed(amount);
          }),
    );
  }


  _buildTitleWidget() {
    return Text(
      "Enter Commission",
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
            color: Colors.red,
          ),
        ));
  }
}
