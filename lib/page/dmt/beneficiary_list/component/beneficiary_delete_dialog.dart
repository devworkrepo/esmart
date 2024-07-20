import 'package:flutter/material.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/mixin/dialog_helper_mixin.dart';

class DeleteBeneficiaryDialog extends StatefulWidget {
  final Function(String) onDeleteConfirm;

  const DeleteBeneficiaryDialog({required this.onDeleteConfirm, Key? key})
      : super(key: key);

  @override
  _DeleteBeneficiaryDialogState createState() =>
      _DeleteBeneficiaryDialogState();
}

class _DeleteBeneficiaryDialogState extends State<DeleteBeneficiaryDialog>
    with DialogHelperMixin {
  var otpController = TextEditingController();
  var otp = "";

  @override
  Widget build(BuildContext context) {
    return buildBaseContainer(
        child: Column(
          children: [
            OtpTextField(
              controller: otpController,
              maxLength: 4,
            ),
            const SizedBox(
              height: 24,
            ),
            AppButton(
              text: "Delete",
              onClick: () {
                otp = otpController.text.toString();
                if (otp.length == 4) {
                  widget.onDeleteConfirm(otp);
                }
              },
            )
          ],
        ),
        title: "Beneficiary Delete");
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
