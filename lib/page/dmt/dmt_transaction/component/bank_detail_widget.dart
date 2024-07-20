import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/res/color.dart';

import '../dmt_transaction_controller.dart';


// ignore: must_be_immutable
class DmtTransactionBankDetailWidget extends GetView<DmtTransactionController> {
   DmtTransactionBankDetailWidget({Key? key}) : super(key: key);

  late bool isBankVerified;
  late String accountNumber;
  late String beneficiaryName;
  late String bankName;
  late String ifscCode;
  late DmtType dmtType;

  @override
  Widget build(BuildContext context) {

    Beneficiary? beneficiary = controller.beneficiary;
    dmtType = controller.dmtType;

      isBankVerified = beneficiary.bankVerified;
      accountNumber = "A/C : " + (beneficiary.accountNumber ?? "");
      beneficiaryName = beneficiary.name ?? "";
      bankName = beneficiary.bankName ?? "";
      ifscCode = beneficiary.ifscCode ?? "";


    return Card(

      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                  image: AssetImage("assets/icon/background2.jpg",),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.purple, BlendMode.modulate)
              )
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Get.theme.primaryColorDark,
            //     Get.theme.primaryColor,
            //     Get.theme.colorScheme.secondary,
            //
            //   ]
            // )
          ),
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
                      style: Get.textTheme.subtitle1
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
                            style: Get.textTheme.headline6
                                ?.copyWith(fontSize: 18, color: Colors.white),
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
                      style: Get.textTheme.subtitle1
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      controller.transferType == DmtTransferType.imps
                          ? "IMPS"
                          : "NEFT",
                      style: Get.textTheme.headline6
                          ?.copyWith(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
            const Divider(),
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
            style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
          ),

          (dmtType == DmtType.instantPay) ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              "Bank : "+bankName,
              style: Get.textTheme.bodyText1?.copyWith(color: Colors.white70),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "IFSC : "+ ifscCode,
              style: Get.textTheme.bodyText1?.copyWith(color: Colors.white70),
            ),
          ],) : SizedBox()
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: AppColor.backgroundColor,
      radius: 25,
      child: Icon(
        Icons.account_balance,
        color: (isBankVerified)
            ? Colors.green
            : Colors.yellow[900],
        size: 40,
      ),
    );
  }

}
