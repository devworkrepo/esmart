import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/investment/investment_list.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import 'package:esmartbazaar/widget/common/report_action_button.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/page/report/report_search.dart';
import '../../report/widget/summary_header.dart';
import 'investment_list_controller.dart';

class InvestmentListPage extends GetView<InvestmentListController> {
  const InvestmentListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentListController());

    return WillPopScope(
      onWillPop: () async {
        if (controller.goHome) {
          Get.offAllNamed(AppRoute.mainPage);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Investment List"),
          ),
          body: Obx(
              () => controller.reportResponseObs.value.when(onSuccess: (data) {
                    if (data.code == 1) {
                      if (data.reports!.isEmpty) {
                        return const NoItemFoundWidget();
                      } else {
                        return _buildListBody(data);
                      }
                    } else {
                      return ExceptionPage(error: Exception(data.message));
                    }
                  }, onFailure: (e) {
                    print(e.toString());
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
          })),
    );
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: controller.searchStatus,
          inputFieldOneTile: "Transaction Number",
          statusList: const [
            "Active",
            "Closed",
            "Completed",
            "Settled",
            "Rejected",
            "Queued",
          ],
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.searchStatus = status;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody(InvestmentListResponse data) {
    var list = data.reports!;
    var count = list.length + 1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        color: Colors.white,
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 4,
          right: 4,
          top: 4,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  SummaryHeaderWidget(
                    transactionCount: list.length,
                    totalWithdrawn: data.total_withamt.toString(),
                    summaryHeader1: [
                      SummaryHeader(
                          title: "Total Amt",
                          value: "${data.totalamt}",
                          backgroundColor: Colors.blue[800]),
                      SummaryHeader(
                          title: "Total Int",
                          value: "${data.total_int}",
                          backgroundColor: Colors.green[800]),
                      SummaryHeader(
                          title: "Maturity Amt",
                          value: "${data.total_int}",
                          backgroundColor: Colors.purple[800]),
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
              list[index - 1],
              controller: controller,
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final InvestmentListItem report;
  final InvestmentListController controller;

  const _BuildListItem(this.report, {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = report.trans_status.toString().toLowerCase();
    var statusColor = Colors.blue[700];
    var statusIcon = Icons.query_builder_outlined;

    if (status == "active" || status == "completed" || status == "settled") {
      statusColor = Colors.green[700];
      statusIcon = Icons.check_circle_outline;
    } else if (status == "closed" || status == "rejected") {
      statusColor = Colors.red[700];
      statusIcon = Icons.cancel_outlined;
    } else if (status == "closed") {
      statusColor = Colors.red[700];
      statusIcon = Icons.cancel_outlined;
    }

    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Card(
          color: Colors.blueGrey[50],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Center(
                        child: Text(
                      "Date : ${report.addeddate}",
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w500),
                    )),
                    Spacer(),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                            color: statusColor?.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              report.trans_status.toString(),
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              statusIcon,
                              color: statusColor,
                              size: 20,
                            )
                          ],
                        )),
                  ],
                ),
                Text("Investment No. ${report.fd_refno}"),
                Divider(
                  indent: 0,
                  color: Colors.grey[300],
                ),
                Row(
                  children: [
                    _BuildSubItem(
                      title: "Amount",
                      value: AppConstant.rupeeSymbol + report.amount.toString(),
                    ),
                    _BuildSubItem(
                      title: "Tenure",
                      value: report.tenure_value.toString() +
                          " " +
                          report.tenure_type.toString(),
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    _BuildSubItem(
                      title: "Mature Amt.",
                      value: AppConstant.rupeeSymbol +
                          report.mature_amount.toString(),
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ],
                ),
                Divider(
                  indent: 0,
                  color: Colors.grey[300],
                ),
                Row(
                  children: [
                    _BuildSubItem(
                      title: "Int. Rate",
                      value: report.int_rate.toString() + " %",
                    ),
                    _BuildSubItem(
                      title: "Int. Earned",
                      value: AppConstant.rupeeSymbol +
                          report.int_earned.toString(),
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    _BuildSubItem(
                      title: "Current Amt.",
                      value: AppConstant.rupeeSymbol +
                          report.current_amount.toString(),
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildSubItem extends StatelessWidget {
  final String title;
  final String value;
  final MainAxisAlignment mainAxisAlignment;

  const _BuildSubItem(
      {required this.title,
      required this.value,
      this.mainAxisAlignment = MainAxisAlignment.start,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Column(
            children: [
              Text(
                title,
                style: Get.textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w400, color: Colors.blueGrey),
              ),
              Text(
                value,
                style: Get.textTheme.subtitle2
                    ?.copyWith(fontSize: 14, color: Colors.black87),
              ),
            ],
          )
        ],
      ),
    );
  }
}
