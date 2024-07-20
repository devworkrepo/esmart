import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/aeps/aeps_bank.dart';
import 'package:esmartbazaar/model/aeps/settlement/bank.dart';
import 'package:esmartbazaar/page/investment/bank_list/investment_bank_list_controller.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/exception.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

class InvestmentBankListPage extends GetView<InvestmentBankListController> {
  const InvestmentBankListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentBankListController());
    return Scaffold(

      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text((controller.fromHome) ? "Settlement Bank Accounts" : "Select Bank Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [

         Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                Text("Add New Bank",style: Get.textTheme.subtitle1?.copyWith(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold
                ),),
              SizedBox(width: 12,),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Get.toNamed(AppRoute.addSettlementBank, arguments: true);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.add),
                  ),
                )
              ],),
            ),
          ),
          SizedBox(height: 12,),


          Expanded(child: ObsResourceWidget<AepsSettlementBankListResponse>(
              obs: controller.responseObs,
              childBuilder: (data) {
                if (data.code == 1) {
                  if (data.banks!.isNotEmpty) {
                    return _BuildList(banks : data.banks!);
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
              })),

          Obx(()=>(controller.buttonText.value.isNotEmpty) ? SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
              ),
                onPressed: (){
                Get.toNamed(AppRoute.investmentTransferPage,arguments: {
                  "bank" : controller.previousBank!,
                  "item" : controller.item
                });
                }, child: Text(controller.buttonText.value)),
          ) : SizedBox())

        ],),
      ),
    );
  }

}

class _BuildList extends GetView<InvestmentBankListController> {
  final List<AepsSettlementBank> banks;
  const _BuildList({required this.banks,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
        itemCount: banks.length,
        itemBuilder: (context, index) {
          var bank = banks[index];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => controller.onItemClick(bank),
            child: Card(
              elevation: 2,
              child: Obx(() {
                return Container(
                  decoration: (bank.isSelected.value)
                      ? BoxDecoration(
                      border: Border.all(color: Colors.green,width: 2),
                      borderRadius: BorderRadius.circular(4))
                      : null,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                bank.bankName.toString(),
                                style: Get.textTheme.headline6,
                              ),
                              Text(
                                bank.accountNumber.toString(),
                                style: Get.textTheme.subtitle2
                                    ?.copyWith(
                                    color: Colors.black87,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Spacer(),
                          (bank.isSelected.value)
                              ? Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                              : SizedBox()
                        ],
                      ),
                      Divider(indent: 0, color: Colors.grey[400]),
                      _BuildSubItem(
                          title: "Name",
                          value: bank.accountName.toString()),
                      _BuildSubItem(
                          title: "IFSC   ",
                          value: bank.ifscCode.toString()),
                    ],
                  ),
                );
              }),
            ),
          );
        });
  }
}


class _BuildSubItem extends StatelessWidget {
  final String title;
  final String value;

  const _BuildSubItem({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),
        ),
        Text("  :  "),
        Text(
          value,
          style: Get.textTheme.caption
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ],
    );
  }
}
