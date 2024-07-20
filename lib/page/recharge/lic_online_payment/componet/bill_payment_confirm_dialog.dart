import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/list_component.dart';

class BillPaymentConfirmDialogWidget extends StatelessWidget {
  final String mobileNumber;
  final String kNumber;
  final String amount;
  final String operatorName;
  final String operatorImageUrl;
  final Function onConfirm;

  const BillPaymentConfirmDialogWidget(
      {required this.mobileNumber,
      required this.kNumber,
      required this.amount,
      required this.operatorName,
      required this.operatorImageUrl,
      required this.onConfirm,
      Key? key})
      : super(key: key);

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
            _buildContent(),
          ],
        ),
      ),
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

  _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Confirm Bill Payment ?",
          style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            AppCircleNetworkImage(
              operatorImageUrl,
              horizontalPadding: 0,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    operatorName +"",
                    style: Get.textTheme.subtitle1,
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    kNumber,
                    style: Get.textTheme.subtitle2?.copyWith(fontWeight: FontWeight.normal,fontSize: 16),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),

        Text("Amount",style: Get.textTheme.headline6?.copyWith(color: Colors.black54,fontWeight: FontWeight.normal),),
        Text(amount,style: Get.textTheme.headline2?.copyWith(color: Colors.green,fontSize: 30),),

        const SizedBox(
          height: 16,
        ),
        AppButton(text: "Confirm", onClick: () {
          Get.back();
          onConfirm();
        })
      ],
    );
  }

}
