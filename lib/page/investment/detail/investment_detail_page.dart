import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/investment/investment_list.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_constant.dart';

class InvestmentDetailPage extends StatelessWidget {
  const InvestmentDetailPage({Key? key}) : super(key: key);

  statusColor(String? value){
    var status = value.toString().toLowerCase();
    var statusColor = Colors.blue[700];

    if (status == "active" || status == "completed" || status == "settled") {
      statusColor = Colors.green[700];
    } else if (status == "closed" || status == "rejected") {
      statusColor = Colors.red[700];
    } else if (status == "closed") {
      statusColor = Colors.red[700];
    }

    return statusColor;
  }

  statusIcon (String? value){
    var status = value.toString().toLowerCase();
    var statusIcon = Icons.query_builder_outlined;

    if (status == "active" || status == "completed" || status == "settled") {
      statusIcon = Icons.check_circle_outline;
    } else if (status == "closed" || status == "rejected") {
      statusIcon = Icons.cancel_outlined;
    } else if (status == "closed") {
      statusIcon = Icons.cancel_outlined;
    }

    return statusIcon;
  }

  @override
  Widget build(BuildContext context) {
    InvestmentListItem item = Get.arguments;



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Investment Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Status  :  ",
                    style: Get.textTheme.bodyText1,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: statusColor(item.trans_status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.trans_status.toString(),
                            style: TextStyle(
                                color: statusColor(item.trans_status),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            statusIcon(item.trans_status),
                            color: statusColor(item.trans_status),
                            size: 20,
                          )
                        ],
                      )),
                  Spacer(),
                  if(item.pay_status.toString().isNotEmpty)Text(
                    "Payment  :  ",
                    style: Get.textTheme.bodyText1,
                  ),
                  if(item.pay_status.toString().isNotEmpty)  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: statusColor(item.pay_status)?.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.pay_status.toString(),
                            style: TextStyle(
                                color: statusColor(item.pay_status),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            statusIcon(item.pay_status),
                            color: statusColor(item.pay_status),
                            size: 20,
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _BuildItem(title: "Pan No.", value: item.pan_no.toString()),

              _BuildItem(
                  title: "Amount",
                  value: AppConstant.rupeeSymbol + item.amount.toString()),
              _BuildItem(
                  title: "Tenure",
                  value: item.tenure_value.toString() +
                      " " +
                      item.tenure_type.toString()),
              _BuildItem(
                  title: "Int. Rate", value: item.int_rate.toString() + " %"),
              _BuildItem(
                  title: "Int. Earned", value:AppConstant.rupeeSymbol+ item.int_earned.toString() ),

              _BuildItem(
                  title: "Current Balance", value:AppConstant.rupeeSymbol+ item.current_amount.toString() ),

              _BuildItem(
                  title: "Maturity Amount", value:AppConstant.rupeeSymbol+ item.mature_amount.toString() ),
              _BuildItem(
                  title: "Created Date", value: item.addeddate.toString() ),
              _BuildItem(
                  title: "Completion Date", value: item.completedate.toString() ),
              _BuildItem(
                  title: "Closed Date", value: item.addeddate.toString() ),
              _BuildItem(
                  title: "Closed Type", value: item.closedtype.toString() ),
              _BuildItem(
                  title: "Response", value: item.trans_response.toString() ),


              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.toNamed(AppRoute.investmentStatementPage,
                          arguments: {"item": item});
                    },
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(
                          width: 4,
                        ),
                        Text("View Statement")
                      ],
                    ),
                  ),
                  Spacer(),
                  if (item.isclosebtn ?? false)
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          Get.toNamed(AppRoute.investmentBankListPage,
                              arguments: {"origin": false, "item": item});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Close Investment")
                          ],
                        )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final String value;

  const _BuildItem({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: Get.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  )),
              Text("  :  "),
              Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: Get.textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
        Divider(
          indent: 0,
          color: Colors.grey[300],
        )
      ],
    );
  }
}
