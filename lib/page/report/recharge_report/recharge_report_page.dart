import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/report/recharge.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../../widget/common/report_action_button.dart';
import '../receipt_print_mixin.dart';
import '../report_helper.dart';
import '../report_search.dart';
import '../widget/summary_header.dart';
import 'recharge_report_controller.dart';

class RechargeReportPage extends GetView<RechargeReportController> {
  final String origin;

  const RechargeReportPage({required this.origin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeReportController(origin));

    return Scaffold(
        appBar: (origin == "summary")
            ? AppBar(
                title: const Text("Utility InProgress"),
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
          status: (origin != "summary") ? controller.searchStatus : null,
          inputFieldOneTile: "Request Number",
          statusList: const [
            "Success",
            "InProgress",
            "Initiated",
            "Failed",
            "Refund Pending",
            "Refunded",
          ],
          serviceTypeList: const [
            "Prepaid",
            "DTH",
            "Mobile Postpaid",
            "Landline Postpaid",
            "Electricity",
            "GAS",
            "Water",
            "CMS",
            "Insurance",
            "Loan",
            "Fastag",
            "Education",
            "Entertainment",
            "Cable",
            "Broadband Postpaid",
            "LPG GAS",
            "Municipal Taxes",
            "Housing Society",
            "Municipal Services",
            "Hospital",
            "Subscription"
          ],
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,
              rechargeType, _) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            if (origin != "summary") {
              controller.searchStatus = status;
            }
            controller.rechargeType = rechargeType;
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
              return Obx(() {
                var mData = controller.summaryReport.value!;
                return Column(
                  children: [
                    SummaryHeaderWidget(
                      summaryHeader1: [
                        SummaryHeader(
                            title: "Total\nTransactions",
                            value: "${mData.total_count}",
                            isRupee: false),
                        SummaryHeader(
                            title: "Total\nAmount",
                            value: "${mData.total_amt}"),
                        SummaryHeader(
                            title: "Charges\nPaid",
                            value: "${mData.charges_paid}"),
                      ],
                      summaryHeader2: [
                        SummaryHeader(
                            title: "Commission\nReceived",
                            value: "${mData.comm_rec}"),
                        SummaryHeader(
                            title: "Refund\nPending",
                            value: "${mData.refund_pending}",
                            isRupee: false),
                        SummaryHeader(
                            title: "Refunded\nTransactions",
                            value: "${mData.refunded}",
                            isRupee: false),
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
              list[index-1],
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<RechargeReportController> {
  final RechargeReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: "" + report.mobileNumber.orNA(),
        subTitle: report.rechargeType.orNA().toUpperCase(),
        date: "Date : " + report.transactionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2: (controller.origin == "summary")
            ? _requeryButton(Get.theme.primaryColorDark, Colors.white)
            : null,
        expandList: [
          ListTitleValue(
              title: "Operator Name", value: report.operatorName.toString()),
          ListTitleValue(
              title: "Transaction No.",
              value: report.transactionNumber.toString()),
          ListTitleValue(title: "Ref/UTR", value: report.payId.toString()),
          ListTitleValue(
              title: "Ref Mobile No", value: report.refMobileNumber.toString()),
          ListTitleValue(
              title: "Operator Ref",
              value: report.operatorRefNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionResponse.toString()),
        ],
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _requeryButton(Colors.white, Colors.black),
            SizedBox(
              width: 8,
            ),
            ReportActionButton(
              title: "Print",
              icon: Icons.print,
              onClick: () {
                controller.printReceipt(
                    (report.transactionNumber ?? ""), ReceiptType.recharge);
              },
            ),
            // const SizedBox(
            //   width: 8,
            // ),
            // ReportActionButton(
            //   title: "Complaint",
            //   icon: Icons.messenger_outline,
            //   onClick: () {
            //     controller.postNewComplaint({
            //       "transactionNumber": report.transactionNumber.toString(),
            //       "type":"Utility"
            //     });
            //   },
            // )
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
