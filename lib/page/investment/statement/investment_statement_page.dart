import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/investment/investment_statement.dart';
import 'package:esmartbazaar/page/investment/statement/investment_statement_controller.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/statement/account_statement.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../report/report_search.dart';
import '../../report/widget/summary_header.dart';

class InvestmentStatementPage extends GetView<InvestmentStatementController> {


  const InvestmentStatementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentStatementController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Investment Statement"),
      ),
        body: Obx(() => controller.reportResponseObs.value.when(onSuccess: (data) {
              if (data.code == 1) {
                if (data.reportList!.isEmpty) {
                  return const NoItemFoundWidget();
                } else {
                  return _buildListBody(data);
                }
              } else {
                return ExceptionPage(error: Exception(data.message));
              }
            }, onFailure: (e) {
              return ExceptionPage(error: e);
            }, onInit: (data) {
              return ApiProgress(data);
            })),
        floatingActionButton: Obx(() {
          return (controller.showFabObs.value)
              ? FloatingActionButton.extended(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearch(),
              label: const Text("Search"))
              : const SizedBox();
        }));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody(InvestmentStatementResponse data) {

    var list = data.reportList!;
    var count = list.length + 1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2)
        ),
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 4,
          right: 4,
          top: 4,
        ),
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {
            if (index == 0) {
             return  Column(
                children: [
                  SummaryHeaderWidget(
                    totalCreditedAmount: data.totalcr,
                    totalDebitedAmount: data.totaldr,
                    availableBalance: data.balance,
                    availableBalanceInWord: data.words,
                    transactionCount: list.length,
                    balanceTitle: "Current Balance",
                    extraValue1: "Investment No. : ${data.fdrefno}",
                    summaryHeader1: [
                      SummaryHeader(
                          title: "Opening Amt.",
                          value: "${data.openamt}",
                          backgroundColor: Colors.green[800],
                          valueFont: 14
                      ),
                      SummaryHeader(
                          title: "Maturity Amt.",
                          value: "${data.matureamt}",
                          backgroundColor: Colors.blue[800],
                          valueFont: 14
                      ),
                      SummaryHeader(
                          title: "Rate Of Int",
                          value: "${data.roi} %",
                          isRupee: false,
                          backgroundColor: Colors.blue[800],
                          valueFont: 14),

                    ],
                    summaryHeader2: [

                      SummaryHeader(
                          title: "Opening Date",
                          value: "${data.opendate}",
                          backgroundColor: Colors.blueGrey[800],
                          isRupee: false,
                          valueFont: 12),
                      SummaryHeader(
                          title: "Completion Date",
                          value: "${data.completedate}",
                          backgroundColor: Colors.blueGrey[800],
                          isRupee: false,
                          valueFont: 12),
                      SummaryHeader(
                          title: "Tenure",
                          value: "${data.tenure}",
                          backgroundColor: Colors.blue[800],
                          isRupee: false,
                          valueFont: 14),

                    ],
                    callback: () {
                      _onSearch();
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  )
                ],
              );
            }

            return _BuildListItem(
              list[index-1],
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<InvestmentStatementController> {
  final InvestmentStatement report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inAmount = double.parse(report.in_amt.toString());
    var outAmount = double.parse(report.out_amt.toString());
    var inCommission = double.parse(report.in_comm.toString());
    var outCommission = double.parse(report.out_comm.toString());
    var inTds = double.parse(report.in_tds.toString());
    var outTds = double.parse(report.out_tds.toString());
    var inCharge = double.parse(report.in_charge.toString());
    var outCharge = double.parse(report.out_charge.toString());

    var headerStyle = Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUpperSection(),
        const SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                    children: [
                      const Text("Amount"),
                      Text(
                        inAmount > 0.0 ? inAmount.toString() : outAmount.toString(),
                        style: TextStyle(
                            color: (inAmount > 0) ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )),
              Expanded(
                  child: Column(
                    children: [
                      Text("Charge", style: headerStyle),
                      Text(
                          inCharge > 0.0
                              ? inCharge.toString()
                              : outCharge.toString(),
                          style: TextStyle(
                              color: (inCharge > 0) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500))
                    ],
                  )),
              Expanded(
                  child: Column(
                    children: [
                      Text("Interest", style: headerStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
                      Text(
                          inCommission > 0.0
                              ? inCommission.toString()
                              : outCommission.toString(),
                          style: TextStyle(
                              color: (inCommission > 0) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500))
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  )),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Tds",
                        style: headerStyle,
                      ),
                      Text(inTds > 0.0 ? inTds.toString() : outTds.toString(),
                          style: TextStyle(
                              color: (inTds > 0) ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500))
                    ],
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Narration : " + report.narration.toString(),
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Remark    : " + report.remark.toString(),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        const Divider(
          indent: 0,
        )
      ],
    );
  }

  Widget _buildUpperSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.date.toString()),
              ],
            ),
          ),
          Expanded(
              child: Column(
                children: [
                  Text(
                    "Balance",
                    style: Get.textTheme.bodyText1,
                  ),
                  Text(
                    report.balance.toString(),
                    style: Get.textTheme.headline6,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ))
        ],
      ),
    );
  }
}
