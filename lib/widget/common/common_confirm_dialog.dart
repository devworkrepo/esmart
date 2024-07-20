import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';

import '../text_field.dart';

class CommonConfirmDialogWidget extends StatelessWidget {
  final Function onConfirm;
  final String title;
  final String? description;
  final String buttonText;

  const CommonConfirmDialogWidget({
    required this.onConfirm,
    this.title = "Confirm ?",
    this.buttonText = "Confirm & Proceed",
    this.description,
    Key? key,
  }) : super(key: key);

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
                _buildDescription(),
                _buildConfirmButtonWidget()
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildDescription() {
    if (description == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        description!,
        style: Get.textTheme.subtitle2?.copyWith(
          color: Colors.grey[600]
        ),
        textAlign: TextAlign.center,
      ),
    );
  }



  _buildConfirmButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: AppButton(
          text: buttonText,
          onClick: () {
            Get.back();
            onConfirm();
          }),
    );
  }


  _buildTitleWidget() {
    return Text(
      title,
      style: Get.textTheme.headline5,
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
