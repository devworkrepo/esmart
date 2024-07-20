import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import 'package:esmartbazaar/widget/common/report_action_button.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/page/report/report_search.dart';
import '../widget/summary_header.dart';
import 'upi_report_controller.dart';

class UpiReportPage extends GetView<UpiReportController> {

  final String origin;



  const UpiReportPage(
      {Key? key, required this.origin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiReportController( origin));

    return Scaffold(
        appBar: (origin == "summary")
            ? AppBar(
                title: const Text(
                    "UPI InProgress"
                ),
              )
            : null,
        body: Obx(
            () => controller.reportResponseObs.value.when(onSuccess: (data) {
                  if (data.code == 1) {
                    if (data.reports!.isEmpty) {
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
        floatingActionButton: Obx((){


          return (controller.reportList.isEmpty) ? FloatingActionButton.extended(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearch(),
              label: const Text("Search")) : const SizedBox();
        }));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: (origin != "summary") ? controller.searchStatus : null,
          inputFieldOneTile: "Transaction Number",
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            if (origin != "summary") {
              controller.searchStatus = status;
            }
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.reportList;
    var count = list.length+1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
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

            if(index == 0){
              return const SizedBox();
              return Obx((){
                var mData = controller.summaryReport.value!;
                return Column(
                  children: [
                    SummaryHeaderWidget(
                      summaryHeader1: [
                        SummaryHeader(title: "Total\nTransactions", value: "${mData.total_count}",isRupee: false),
                        SummaryHeader(title: "Total\nAmount", value: "${mData.total_amt}"),
                        SummaryHeader(title: "Charges\nPaid", value: "${mData.charges_paid}"),

                      ],
                      summaryHeader2: [
                        SummaryHeader(title: "Commission\nReceived", value: "${mData.comm_rec}"),
                        SummaryHeader(title: "Refund\nPending", value: "${mData.refund_pending}",isRupee: false),
                        SummaryHeader(title: "Refunded\nTransactions", value: "${mData.refunded}",isRupee: false),
                      ],
                      callback: (){
                        _onSearch();
                      },
                    ),
                    const SizedBox(height: 12,)
                  ],
                );
              });
            }
            return _BuildListItem(
              list[index-1],
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
  final MoneyReport report;
  final UpiReportController controller;

  const _BuildListItem(this.report, {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: "Upi Id    : " + report.accountNumber.orNA(),
        subTitle: "Name    : "+report.beneficiaryName.orNA(),
        date: "Date : " + report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2: (controller.origin == "summary")
            ? _requeryButton(Get.theme.primaryColorDark, Colors.white)
            : null,
        expandList: [
          ListTitleValue(
              title: "Remitter Number", value: report.senderNubber.toString()),
          ListTitleValue(
              title: "Txn Number", value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Beneficiary Name",
              value: report.beneficiaryName.toString()),
          ListTitleValue(
              title: "UPI Id", value: report.accountNumber.toString()),
          ListTitleValue(
              title: "Transaction Type",
              value: report.transactionType.toString()),
          ListTitleValue(
              title: "Commission", value: report.commission.toString()),
          ListTitleValue(title: "Charge", value: report.charge.toString()),
          ListTitleValue(
              title: "UTR Number", value: report.utrNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionMessage.toString()),
        ],
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _requeryButton(Colors.white, Colors.black),
            const SizedBox(
              width: 8,
            ),
            ReportActionButton(
              title: "Print",
              icon: Icons.print,
              onClick: () {
                  controller.printReceipt(
                      (report.calcId ?? ""), ReceiptType.upi);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _requeryButton(Color background, Color color) {
    return (report.transactionStatus!.toLowerCase() == "inprogress" ||
            kDebugMode)
        ? ReportActionButton(
            title: "Re-query",
            icon: Icons.refresh,
            onClick: () {
              controller.requeryTransaction(report);
            },
            color: color,
            background: background,
          )
        : const SizedBox();
  }
}
