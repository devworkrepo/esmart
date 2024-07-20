import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import '../../../res/style.dart';
import '../../../route/route_name.dart';
import '../../../widget/text_field.dart';
import 'select_bank_controller.dart';

class SelectAepsSettlementBankPage
    extends GetView<SelectSettlementBankController> {
  const SelectAepsSettlementBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SelectSettlementBankController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Settlement Banks"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _addNewBankWidget(),
              Expanded(
                  child: ObsResourceWidget<AepsSettlementBankListResponse>(
                obs: controller.responseObs,
                childBuilder: (data) {
                  if (data.code == 1) {
                    if (data.banks!.isNotEmpty) {
                      return _BankListWidget();
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
                },
                handleCode: true,
              ))
            ],
          ),
          if (false)
            Obx(() => (!controller.showSearchBoxObs.value)
                ? const SizedBox()
                : Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      width: Get.width,
                      decoration: AppStyle.searchDecoration(
                          color: Colors.black38, borderRadius: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppSearchField(
                              onChange: controller.onSearchChange,
                            ),
                          ),
                        ],
                      ),
                    )))
        ],
      ),
    );
  }

  Widget _addNewBankWidget() {
    return SizedBox(
      width: Get.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Aeps Balance",
                style: Get.textTheme.bodyText1
                    ?.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Obx(() {
                var amount = controller.aepsBalance.value.balance ?? 0;
                return Text(
                  "₹ $amount ",
                  style: Get.textTheme.headline3?.copyWith(color: Colors.green),
                );
              }),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildHeaderIcon(
                        "Add Account", Icons.add, Colors.green, () {
                      Get.toNamed(AppRoute.addSettlementBank, arguments: true);
                    }),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: _buildHeaderIcon(
                        "Import Accounts", Icons.sync, Colors.blue, () {
                      controller.onImportClick();
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(
      String title, IconData iconData, Color color, VoidCallback callback) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: callback,
          child: Row(
            children: [
              Icon(iconData),
              SizedBox(
                width: 8,
              ),
              Text(title),
            ],
          ),
          style: ElevatedButton.styleFrom(primary: color),
        )
      ],
    );
  }
}

class _BankListWidget extends GetView<SelectSettlementBankController> {
  _BankListWidget({Key? key}) : super(key: key);

  final appPreference = Get.find<AppPreference>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Obx(() => ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: controller.beneficiaryListObs.length,
          itemBuilder: (context, index) {
            AepsSettlementBank bank = controller.beneficiaryListObs[index];
            return GestureDetector(
              onTap: () {
                bank.isSelected.value = !bank.isSelected.value;
                bank.transferAmount.value = 0;
              },
              child: Obx(() => Container(
                    color: (bank.isSelected.value)
                        ? Colors.blue.shade50
                        : Colors.grey.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        foregroundColor: Colors.green,
                                        radius: 18,
                                        child: Icon(Icons.person),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bank.accountName.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            bank.bankName.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue[800]),
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            bank.ifscCode.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            bank.accountNumber.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red[800]),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Obx(() => Visibility(
                                      visible: bank.isSelected.value,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    AmountOutlineTextFieldMini(
                                                  onChange: (value) {
                                                    if (value != null) {
                                                      final amount = value
                                                          .replaceAll("₹", "")
                                                          .trim();
                                                      bank.transferAmount
                                                              .value =
                                                          int.parse(amount);
                                                    } else {
                                                      bank.transferAmount
                                                          .value = 0;
                                                    }
                                                  },
                                                ),
                                              ),
                                              Spacer(),
                                              SizedBox(
                                                height: 42,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (bank.transferAmount
                                                                .value >=
                                                            100 &&
                                                        double.parse(bank
                                                                .transferAmount
                                                                .value
                                                                .toString()) <=
                                                            double.parse(controller
                                                                .aepsBalance
                                                                .value
                                                                .balance
                                                                .toString())) {
                                                      controller
                                                          .onTransferClick(
                                                              bank);
                                                    }
                                                  },
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.send,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "Transfer",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: Colors.green,
                                                          onPrimary:
                                                              Colors.black),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () => controller
                                                    .onDeleteClick(bank),
                                                child: SizedBox(
                                                    height: 42,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: Colors.white,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                          Obx(() => Column(
                                                children: [
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    (bank.transferAmount.value <
                                                            100)
                                                        ? "Enter amount minimum 100"
                                                        : (double.parse(bank
                                                                    .transferAmount
                                                                    .value
                                                                    .toString()) >
                                                                double.parse(controller
                                                                    .aepsBalance
                                                                    .value.balance
                                                                    .toString()))
                                                            ? "Insufficient amount"
                                                            : "Enter settlement amount",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.grey[600]),
                                                  )
                                                ],
                                              ))
                                        ],
                                      )))
                                ],
                              ),
                            )),
                          ],
                        ),
                        const Divider(
                          indent: 0,
                        )
                      ],
                    ),
                  )),
            );
          })),
    );
  }
}
