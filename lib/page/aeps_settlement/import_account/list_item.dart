import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';


class ImportSettlementBankListWidget extends StatelessWidget {
  final List<AepsSettlementBank> beneficiaryList;
  final RxList<AepsSettlementBank> selectedListObs;

  const ImportSettlementBankListWidget(
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

  _buildListItem(AepsSettlementBank beneficiary) {
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
                          Text(
                            beneficiary.accountName ?? "",
                            style: Get.textTheme.subtitle1?.copyWith(
                                color: Colors.black),
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

