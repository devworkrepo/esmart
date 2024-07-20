import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../model/dmt/beneficiary.dart';

class ImportBeneficiaryListWidget extends StatelessWidget {
  final List<Beneficiary> beneficiaryList;
  final RxList<Beneficiary> selectedListObs;

  const ImportBeneficiaryListWidget(
      {required this.beneficiaryList, required this.selectedListObs, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: beneficiaryList.length,
              itemBuilder: (context, index) =>
                  _buildListItem(beneficiaryList[index])),
        ),
      ),
    );
  }

  _buildListItem(Beneficiary beneficiary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      (beneficiary.validateStatus!.toLowerCase() == "success")
                          ? const Icon(
                              Icons.verified,
                              size: 20,
                              color: Colors.green,
                            )
                          : const SizedBox(),
                      Text(
                        beneficiary.name ?? "",
                        style: Get.textTheme.subtitle1?.copyWith(
                            color: (beneficiary.validateStatus!.toLowerCase() ==
                                    "success"
                                ? Colors.green
                                : Colors.black)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "A/c No. : " + (beneficiary.accountNumber ?? ""),
                    style: Get.textTheme.bodyText1,
                  ),
                  Text(
                    "Bank      : " + (beneficiary.bankName ?? ""),
                    style: Get.textTheme.bodyText1,
                  ),
                  Text(
                    "Ifsc        : " + (beneficiary.ifscCode ?? ""),
                    style: Get.textTheme.bodyText1,
                  ),
                ],
              ),
            )),
            Obx(() => Checkbox(
                value: beneficiary.isSelectedForImport.value,
                onChanged: (value) {
                  beneficiary.isSelectedForImport.value = value!;
                  if (value) {
                    selectedListObs.add(beneficiary);
                  } else {
                    selectedListObs.remove(beneficiary);
                  }
                }))
          ],
        ),
        Divider(
          indent: 0,
        )
      ],
    );
  }
}


class ImportBeneficiaryMessage {
  final Beneficiary beneficiary;
  final String message;
  final int code;

  ImportBeneficiaryMessage(this.code, this.beneficiary, this.message);
}
