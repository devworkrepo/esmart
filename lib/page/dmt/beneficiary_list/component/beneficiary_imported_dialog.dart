import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';

import '../../import_beneficiary/common.dart';
import '../../import_beneficiary/from_sender/import_sender_controller.dart';

class BeneficiaryImportedDialog extends StatelessWidget {
  final List<ImportBeneficiaryMessage> importedList;

  const BeneficiaryImportedDialog(this.importedList, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Beneficiary Imported",
              style: Get.textTheme.headline3
                  ?.copyWith(color: Get.theme.primaryColor),
            ),
            const SizedBox(
              height: 12,
            ),
            ...importedList.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              e.beneficiary.name ?? "",
                              style: Get.textTheme.subtitle1,
                            ),
                            Text(
                              e.message,
                              style: TextStyle(
                                  color: (e.code == 1)
                                      ? Colors.green
                                      : Colors.red),
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )),
                      Icon(
                        (e.code == 1) ? Icons.verified_outlined : Icons.cancel,
                        color: (e.code == 1) ? Colors.green : Colors.red,
                      )
                    ],
                  ),
                  const Divider(
                    indent: 0,
                  )
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(text: "Done", onClick: (){
                Get.back();
              }),
            )
          ],
        ),
      ),
    );
  }
}
