import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/statement/account_statement.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../report/report_search.dart';
import '../../report/widget/summary_header.dart';
import 'account_statement_controller.dart';

class AccountStatementPage extends GetView<AccountStatementController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;


  const AccountStatementPage({Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountStatementController(controllerTag), tag: controllerTag);
    return Scaffold(
      appBar: (controller.appPreference.user.userType == "Sub-Merchant") ? AppBar(
        title: Text("Account Statement"),
      ) : null,
        body: Obx(
            () => controller.reportResponseObs.value.when(onSuccess: (data) {
                  if (data.code == 1) {
                    if (data.reportList!.isEmpty) {
                      return const NoItemFoundWidget();
                    } else {
                      return _buildListBody();
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
          return (controller.reportList.isEmpty)
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

  RefreshIndicator _buildListBody() {
    var list = controller.reportList;
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
              return Obx(() {
                var mData = controller.summaryReport.value!;
                return Column(
                  children: [
                    SummaryHeaderWidget(
                      totalCreditedAmount: mData.total_credit,
                      totalDebitedAmount: mData.total_debit,
                      availableBalance: mData.avail_balance,
                      availableBalanceInWord: mData.balance_words,
                      summaryHeader1: [
                        SummaryHeader(
                            title: "Amount\nCredited",
                            value: "${mData.amt_cr}",
                            backgroundColor: Colors.green[800],
                          valueFont: 14
                        ),
                        SummaryHeader(
                            title: "Amount\nDebited",
                            value: "${mData.amt_dr}",
                            backgroundColor: Colors.red[800],
                            valueFont: 14
                        ),
                        SummaryHeader(
                            title: "Charges\nDeducted",
                            value: "${mData.chg_dr}",
                            backgroundColor: Colors.red[800],
                            valueFont: 14),
                        SummaryHeader(
                            title: "Charges\nReversed",
                            value: "${mData.chg_cr}",
                            backgroundColor: Colors.green[800],
                            valueFont: 14),
                      ],
                      summaryHeader2: [

                        SummaryHeader(
                            title: "Commission\nCredited",
                            value: "${mData.comm_cr}",
                            backgroundColor: Colors.green[800],
                            valueFont: 14),
                        SummaryHeader(
                            title: "Commission\nReversed",
                            value: "${mData.comm_dr}",
                            backgroundColor: Colors.red[800],
                            valueFont: 14),
                        SummaryHeader(
                            title: "TDS\nDeducted",
                            value: "${mData.tds_dr}",
                            backgroundColor: Colors.red[800],
                            valueFont: 14),
                        SummaryHeader(
                            title: "TDS\nReversed",
                            value: "${mData.tds_cr}",
                            backgroundColor: Colors.green[800],
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
              });
            }

            return _BuildListItem(
              list[index - 1],
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<AccountStatementController> {
  final AccountStatement report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inAmount = double.parse(report.inAmount.toString());
    var outAmount = double.parse(report.outAmount.toString());
    var inCommission = double.parse(report.inCommission.toString());
    var outCommission = double.parse(report.outCommission.toString());
    var inTds = double.parse(report.inTds.toString());
    var outTds = double.parse(report.outTds.toString());
    var inCharge = double.parse(report.inCharge.toString());
    var outCharge = double.parse(report.outCharge.toString());

    var headerStyle = Get.textTheme.bodyText1;

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
                  Text("Commission", style: headerStyle,maxLines: 1,overflow: TextOverflow.ellipsis,),
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
