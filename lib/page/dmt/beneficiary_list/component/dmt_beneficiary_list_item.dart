import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/transfer_mode_dailog.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/beneficiary_controller.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/beneficiary_list_mixin.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/route/route_name.dart';

class DmtBeneficiaryListItem extends GetView<BeneficiaryListController>
    with BeneficiaryListMixin {
  final int index;

  const DmtBeneficiaryListItem(this.index, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Beneficiary beneficiary = controller.beneficiaryListObs.value[index];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.onBeneficiaryClick(beneficiary),
      child: Obx(() => Card(
            elevation: 2,
            color: (beneficiary.isExpanded.value)
                ? Get.theme.primaryColorDark
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildVisibleContent(beneficiary),
                  (beneficiary.isExpanded.value)
                      ? buildExpandedContent(
                          isBankVerified: beneficiary.bankVerified,
                          onDelete: () =>
                              controller.deleteBeneficiary(beneficiary),
                          onTransfer: (){},
                          onVerify: () => controller.verifyAccount(beneficiary))
                      : const SizedBox()
                ],
              ),
            ),
          )),
    );
  }


  Row _buildVisibleContent(Beneficiary beneficiary) {
    return Row(
      children: [
        buildAvatar(beneficiary.bankVerified),
        const SizedBox(
          width: 8,
        ),
        buildDmtContent(
          isExpanded : beneficiary.isExpanded.value,
            isBankVerified: beneficiary.bankVerified,
            beneficiaryName: beneficiary.name,
            accountNumber: beneficiary.accountNumber.toString(),
            bankName: beneficiary.bankName,
            ifscCode: beneficiary.ifscCode),
       buildSendButton(beneficiary.isExpanded.value,()=> controller.onSendButtonClick(beneficiary))
      ],
    );
  }

}
