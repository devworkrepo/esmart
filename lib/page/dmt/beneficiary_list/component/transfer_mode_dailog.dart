import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/text_field.dart';

import '../../dmt.dart';

class TransferModeDialog extends StatefulWidget {
  const TransferModeDialog(
      {Key? key,
      required this.beneficiary,
      required this.onClick,
      required this.senderInfo,
      required this.dmtType,
      required this.isLimitView})
      : super(key: key);

  final SenderInfo senderInfo;
  final bool isLimitView;
  final Beneficiary beneficiary;
  final DmtType dmtType;
  final Function(String amount, DmtTransferType type) onClick;

  @override
  _TransferModeDialogState createState() => _TransferModeDialogState();
}

class _TransferModeDialogState extends State<TransferModeDialog>
    with TransactionHelperMixin {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      width: Get.width,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Transaction Mode",
                  style: Get.textTheme.headline3?.copyWith(color: Colors.black),
                ),
                /*  Icon(
                  Icons.account_balance,
                  size: 60,
                  color: Get.theme.primaryColorDark,
                ),
                SizedBox(
                  height: 24,
                ),*/
                /* Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:Get.theme.primaryColorLight),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [


                      BuildTitleValueWidget(
                        color: Colors.white.withOpacity(0.8),
                          title: "Account Holder",
                          value: widget.beneficiary.name ?? ""),
                      BuildTitleValueWidget(
                          color: Colors.white.withOpacity(0.8),
                          title: "Bank Name",
                          value: widget.beneficiary.bankName ?? ""),
                      BuildTitleValueWidget(
                          color: Colors.white.withOpacity(0.8),
                          title: "A.C Number",
                          value: widget.beneficiary.accountNumber ?? ""),
                      BuildTitleValueWidget(
                          color: Colors.white.withOpacity(0.8),
                          title: "IFSC Code",
                          value: widget.beneficiary.ifscCode ?? ""),
                    ],
                  ),
                ),*/
                const SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColor.backgroundColor),
                  padding: EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: AmountTextField(
                      validator: _amountValidation,
                      controller: _amountController,
                      label: "Transfer Amount",
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
                            var amount =
                                amountWithoutRupeeSymbol(_amountController);

                            if (widget.dmtType == DmtType.payout) {
                              if (_validatePayout(amount)) {
                                Get.back();
                                widget.onClick(amount, DmtTransferType.imps);
                                return;
                              }
                            } else if (widget.dmtType == DmtType.dmt2 ||
                                widget.dmtType == DmtType.dmt3) {
                              Get.back();
                              widget.onClick(amount, DmtTransferType.imps);
                              return;
                            } else if (_validateImps(amount)) {
                              Get.back();
                              widget.onClick(amount, DmtTransferType.imps);
                            }
                          }
                        },
                        title: "IMPS Transfer",
                        color: Colors.green),
                    const SizedBox(
                      width: 16,
                    ),
                    _buildButton(
                        onClick: () {
                          if (_validateAmount()) {
                            var amount =
                                amountWithoutRupeeSymbol(_amountController);

                            if (widget.dmtType == DmtType.payout) {
                              if (_validatePayout(amount)) {
                                Get.back();
                                widget.onClick(amount, DmtTransferType.neft);
                                return;
                              }
                            }
                            else if (widget.dmtType == DmtType.dmt2 ||widget.dmtType == DmtType.dmt3) {
                                Get.back();
                                widget.onClick(amount, DmtTransferType.neft);
                                return;
                              }

                             else  if (_validateNeft(amount)) {
                                Get.back();
                                widget.onClick(amount, DmtTransferType.neft);
                                return;
                              }

                          }
                        },
                        title: "NEFT Transfer",
                        color: Get.theme.primaryColor),
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

  Widget _buildButton(
      {VoidCallback? onClick, required String title, required Color color}) {
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
                  child: Icon(Icons.send),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(title)
              ],
            )),
      ),
    );
    return ElevatedButton.icon(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color)),
        onPressed: () {},
        icon: Transform.rotate(
          angle: 12,
          child: Icon(Icons.send),
        ),
        label: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title),
        ));
  }

  bool _validateNeft(String enteredAmount) {
    var enteredAmountInDouble = double.parse(enteredAmount);
    var sender = widget.senderInfo;
    var isKyc = sender.isKycVerified ?? false;
    if (widget.isLimitView) {
      var kycViewLimit = double.parse(sender.neftKycLimitView ?? "0");
      var kycNonViewLimit = double.parse(sender.neftNKycLimitView ?? "0");
      if (isKyc) {
        if (enteredAmountInDouble > kycViewLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      } else {
        if (enteredAmountInDouble > kycNonViewLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      }
    } else {
      var kycAllLimit = double.parse(sender.impsKycLimitAll ?? "0");
      var kycNonAllLimit = double.parse(sender.impsNKycLimitAll ?? "0");
      if (isKyc) {
        if (enteredAmountInDouble > kycAllLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      } else {
        if (enteredAmountInDouble > kycNonAllLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      }
    }
  }

  bool _validateImps(String enteredAmount) {
    var enteredAmountInDouble = double.parse(enteredAmount);
    var sender = widget.senderInfo;
    var isKyc = sender.isKycVerified ?? false;
    if (widget.isLimitView) {
      var kycViewLimit = double.parse(sender.impsKycLimitView ?? "0");
      var kycNonViewLimit = double.parse(sender.impsNKycLimitView ?? "0");
      if (isKyc) {
        if (enteredAmountInDouble > kycViewLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      } else {
        if (enteredAmountInDouble > kycNonViewLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      }
    } else {
      var kycAllLimit = double.parse(sender.impsKycLimitAll ?? "0");
      var kycNonAllLimit = double.parse(sender.impsNKycLimitAll ?? "0");
      if (isKyc) {
        if (enteredAmountInDouble > kycAllLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      } else {
        if (enteredAmountInDouble > kycNonAllLimit) {
          showFailureSnackbar(
              title: "Available Limit Exceeded",
              message: "Your available limit is exceeded!");
          return false;
        } else {
          return true;
        }
      }
    }
  }

  bool _validatePayout(String enteredAmount) {
    var enteredAmountInDouble = double.parse(enteredAmount);
    var sender = widget.senderInfo;
    var payoutTotal = double.parse((sender.payoutTotal ?? "0"));

    if (enteredAmountInDouble > payoutTotal) {
      showFailureSnackbar(
          title: "Available Limit!",
          message:
              "Your available limit is exceeded! ${sender.payoutTotal.toString()}");
      return false;
    } else {
      return true;
    }
  }

  _amountValidation(String? value) {
    if (value == null) {
      return "Enter valid amount";
    }
    AppPreference appPreference = Get.find();
    var minAmount = (widget.dmtType == DmtType.instantPay ||
            widget.dmtType == DmtType.dmt2 ||
            widget.dmtType == DmtType.dmt3)
        ? 100
        : 25001;

    var maxAmount = (widget.dmtType == DmtType.instantPay ||
            widget.dmtType == DmtType.dmt2 ||
            widget.dmtType == DmtType.dmt3)
        ? (widget.senderInfo.isKycVerified ?? false)
            ? 49750
            : 25000
        : 200000;

    var enteredAmountInDouble = double.parse(value);

    var balance = appPreference.user.availableBalance;
    var balanceInDouble = double.parse(balance ?? "0");

    if (enteredAmountInDouble > balanceInDouble) {
      return "Insufficient wallet amount!";
    }

    if (enteredAmountInDouble < minAmount ||
        enteredAmountInDouble > maxAmount) {
      return "Enter amount $minAmount - $maxAmount";
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
