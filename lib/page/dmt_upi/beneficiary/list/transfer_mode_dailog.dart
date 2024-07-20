import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/text_field.dart';


class UpiTransferAmountDialog extends StatefulWidget {
  const UpiTransferAmountDialog(
      {Key? key,
      required this.beneficiary,
      required this.onClick,
      required this.senderInfo})
      : super(key: key);

  final SenderInfo senderInfo;
  final Beneficiary beneficiary;

  final Function(String amount) onClick;

  @override
  _UpiTransferAmountDialogState createState() => _UpiTransferAmountDialogState();
}

class _UpiTransferAmountDialogState extends State<UpiTransferAmountDialog> with TransactionHelperMixin {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))
      ),
      width: Get.width,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text("Transaction Amount",style: Get.textTheme.headline3?.copyWith(color: Colors.black),),

                const SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200]),
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: AmountTextField(
                      validator:_amountValidation,
                      controller: _amountController,
                      label: "Enter Amount",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  children: [
                    _buildButton(
                        onClick: () {
                          if (_validateAmount()) {
                            var amount = amountWithoutRupeeSymbol(_amountController);
                              Get.back();
                              widget.onClick(amount);
                          }
                        },
                        title: "Transfer",
                        color: Colors.green),

                  ],
                )
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
                iconSize: 32,
                color: Colors.grey,
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.cancel)),
          )
        ],
      ),
    );
  }

  bool _validateAmount() {
    return _formKey.currentState!.validate();
  }

  Widget _buildButton({VoidCallback? onClick, required String title, required Color color}) {
    return Expanded(
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
            onPressed: onClick,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 12,
                  child: const Icon(Icons.send),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title)
              ],
            )),
      ),
    );
  }


  _amountValidation(String? value) {
    if (value == null) {
      return "Enter valid amount";
    }
    AppPreference appPreference = Get.find();
    var minAmount = 100 ;
    var maxAmount = double.parse(widget.senderInfo.perentry_limit!)-1.0;

    var enteredAmountInDouble = double.parse(value);

    var balance = appPreference.user.availableBalance;
    var balanceInDouble = double.parse(balance ?? "0");

    if (enteredAmountInDouble > balanceInDouble) {
      return "Insufficient wallet amount!";
    }

    if(enteredAmountInDouble <minAmount || enteredAmountInDouble> maxAmount){
      return "Enter amount $minAmount - $maxAmount";
    }

    else {
      return null;
    }
  }



  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

