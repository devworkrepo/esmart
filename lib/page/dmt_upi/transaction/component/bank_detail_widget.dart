import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/res/color.dart';

import '../upi_transaction_controller.dart';


// ignore: must_be_immutable
class UpiTransactionBankDetailWidget extends GetView<UpiTransactionController> {
   UpiTransactionBankDetailWidget({Key? key}) : super(key: key);

  late bool isBankVerified;
  late String accountNumber;
  late String beneficiaryName;


  @override
  Widget build(BuildContext context) {

    Beneficiary? beneficiary = controller.beneficiary;


      isBankVerified = beneficiary.bankVerified;
      accountNumber = "Upi Id : " + (beneficiary.accountNumber ?? "");
      beneficiaryName = beneficiary.name ?? "";



    return Card(
      color: Get.theme.primaryColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      "Transfer To ",
                      style: Get.textTheme.subtitle2
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        (isBankVerified)
                            ? const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 16,
                              )
                            : const SizedBox(),
                        Expanded(
                          child: Text(
                            beneficiaryName,
                            style: Get.textTheme.subtitle2
                                ?.copyWith( color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
                Column(
                  children: [
                    Text(
                      "Transfer Mode ",
                      style: Get.textTheme.subtitle2
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "IMPS",
                      style: Get.textTheme.subtitle2
                          ?.copyWith( color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const Divider(indent: 0,),
            Row(
              children: [
                _buildAvatar(),
                const SizedBox(
                  width: 8,
                ),
                _buildContent(),
              ],
            ),
          ],
        ),
      ),
    );;

  }

  Widget _buildContent() {

    return Expanded(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            accountNumber,
            style: Get.textTheme.subtitle2?.copyWith(color: Colors.white),
          ),


        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: AppColor.backgroundColor,
      radius: 22,
      child: Icon(
        Icons.account_balance,
        color: (isBankVerified)
            ? Colors.green[900]
            : Colors.grey[900],
        size: 30,
      ),
    );
  }

}
