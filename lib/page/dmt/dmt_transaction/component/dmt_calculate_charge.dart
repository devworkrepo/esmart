import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/model/dmt/calculate_charge.dart';
import 'package:esmartbazaar/page/dmt/dmt_transaction/dmt_transaction_controller.dart';

class DmtCalculateChargeWidget extends GetView<DmtTransactionController> {
  const DmtCalculateChargeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> Card(
      child: Container(
        padding: const EdgeInsets.all(12),
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text("Transaction Numbers",style: Get.textTheme.subtitle1?.copyWith(color: Colors.grey[600]),),
              const Spacer(),

              GestureDetector(
                onTap: ()=> controller.setTransactionChargeWidgetVisibility(),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 1,color: Colors.grey)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  child: Row(children: [
                    Text((controller.transactionChargeWidgetVisibilityObs.value) ? "Hide" : "Show"),
                    SizedBox(width: 8,),
                    Icon((controller.transactionChargeWidgetVisibilityObs.value) ? Icons.visibility_off : Icons.visibility)
                  ],),),
              )

            ],),
            (controller.transactionChargeWidgetVisibilityObs.value)?  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                        child: _chargeCommonText("Amount",
                            color: Colors.black54)),
                    /* Expanded(
                          child: Align(
                              alignment: Alignment.center,
                              child: _chargeCommonText("Charge",
                                  color: Colors.black54))),*/
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: _chargeCommonText("Charge",
                                color: Colors.black54))),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                ...controller.calculateChargeResponse.chargeList!
                    .map((e) => _buildChargeListItem(e)),
              ],) : const SizedBox()
          ],
        ),
      ),
    ));
  }

  _buildChargeListItem(CalculateCharge calculateCharge) {
    return Column(
      children: [
        const Divider(
          indent: 0,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(calculateCharge.srno.toString() +".  ",style: Get.textTheme.headline6,),
            Expanded(
                child: _chargeCommonText(
                  "Rs "+  (calculateCharge.amount ?? "") )),
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: _chargeCommonText(
                        "Rs "+(calculateCharge.charge ?? "") ,
                        color: Colors.red))),
          ],
        ),
      ],
    );
  }

  _chargeCommonText(String text, {Color color = Colors.blue}) {
    return Text(
      text,
      style: Get.textTheme.subtitle1?.copyWith(fontSize: 15, color: color),
    );
  }
}
