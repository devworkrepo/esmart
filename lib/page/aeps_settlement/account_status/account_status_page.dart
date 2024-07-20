import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import 'account_status_controller.dart';

class SettlementAccountStatusPage extends GetView<SettlementAccountStatusController> {
  const SettlementAccountStatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettlementAccountStatusController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settlement Account Status"),
      ),
      body: ObsResourceWidget<AepsSettlementBankListResponse>(
          obs: controller.responseObs,
          childBuilder: (data) {
            if (data.code == 1) {
              if (data.banks!.isNotEmpty) {
                return _BankListWidget(data.banks!);
              } else {
                return const NoItemFoundWidget();
              }
            } else if (data.code == 2) {
              return const NoItemFoundWidget();
            } else {
              return NoItemFoundWidget(
                icon: Icons.info,
                message: data.message,
              );
            }
          },handleCode: true,),
    );
  }
}

class _BankListWidget extends GetView<SettlementAccountStatusController> {
  final List<AepsSettlementBank> list;

  const _BankListWidget(this.list, {Key? key}) : super(key: key);

  _getColor(String status) {
    var statusId = ReportHelperWidget.getStatusId(status);
    if (statusId == 1) {
      return Colors.green[900];
    } else if (statusId == 2) {
      return Colors.red;
    } else {
      return Colors.yellow[900];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
        //  _addNewBankWidget(),
          Expanded(
            child: Card(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    AepsSettlementBank bank = list[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bank.accountNumber ?? "NA",
                                    style: Get.textTheme.subtitle1,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Name : " + (bank.accountName ?? "NA"),
                                    style: Get.textTheme.subtitle2
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Bank  : " + (bank.bankName ?? "NA"),
                                    style: Get.textTheme.subtitle2
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Ifsc    : " + (bank.ifscCode ?? "NA"),
                                    style: Get.textTheme.subtitle2
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            )),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: _getColor(
                                          bank.bankStatus ?? "Pending")),
                                  child: Text(
                                    bank.bankStatus ?? "NA",
                                    style: Get.textTheme.subtitle2
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ElevatedButton(
                                  onPressed: () =>controller.downloadFile(bank),
                                  child: const Icon(
                                    Icons.arrow_circle_down,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          indent: 0,
                        )
                      ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _addNewBankWidget() {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () =>controller.addNewBank(false),
                child: const Icon(Icons.add),
                mini: true,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                "Add New Bank",
                style: Get.textTheme.headline6,
              )
            ],
          ),
        ),
      ),
    );
  }
}
