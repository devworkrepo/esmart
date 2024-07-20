import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/list_component.dart';

class RechargeConfirmationDialog extends StatelessWidget {
  final String mobileNumber;
  final String amount;
  final String operatorName;
  final String operatorImageUrl;
  final Function onConfirm;

  const RechargeConfirmationDialog(
      {required this.mobileNumber,
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
          "Confirm Recharge ?",
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
            Text(
              operatorName,
              style: Get.textTheme.subtitle1,
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        BuildTitleValueWidget(title: "Mobile Number", value: mobileNumber),
        BuildTitleValueWidget(title: "Amount", value: amount),
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

class BuildTitleValueWidget extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final int? fontSize;
  final FontWeight? fontWeight;
  const BuildTitleValueWidget({Key? key,required this.title,required this.value,this.color,this.fontSize,this.fontWeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          BuildLeftListWidget(title,color: color,fontSize: fontSize,fontWeight : fontWeight),
          BuildDotWidget(color : color),
          BuildRightListWidget(value,color: color,fontSize : fontSize,fontWeight : fontWeight)
        ],
      ),
    );
  }
}

