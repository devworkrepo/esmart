import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import '../../../model/report/aeps.dart';
import '../../../widget/common/report_action_button.dart';
import '../receipt_print_mixin.dart';
import '../report_helper.dart';
import '../report_search.dart';
import '../widget/summary_header.dart';
import 'aeps_matm_report_controller.dart';

class AepsMatmReportPage extends GetView<AepsMatmReportController> {
  final String controllerTag;
  final String origin;

  @override
  String? get tag => controllerTag;

  const AepsMatmReportPage(
      {required this.origin, Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsMatmReportController(controllerTag, origin),
        tag: controllerTag);
    return Scaffold(
        appBar: (origin == "summary")
            ? AppBar(
                title: Text((controllerTag == AppTag.aepsReportControllerTag)
                    ? "AEPS InProgress"
                    : (controllerTag == AppTag.aadhaarPayReportControllerTag)
                        ? "Aadhaar Pay InProgress"
                        : ""),
              )
            : null,
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
          if (controller.reportList.isEmpty) {
            return FloatingActionButton.extended(
                icon: const Icon(Icons.search),
                onPressed: () => _onSearch(),
                label: const Text("Search"));
          } else {
            return const SizedBox();
          }
        }));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: (origin != "summary") ? controller.searchStatus : null,
          serviceTypeList: const ["All","AEPS","MATM","MPOS","AADHARPAY"],
          serviceType: controller.getServiceType(),
          inputFieldOneTile: "Transaction Number",
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, serviceType, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.setServiceType(serviceType);
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
    var count = list.length + 1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        margin: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
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
                            title: "Total Transactions",
                            value: "${mData.total_count}",
                            isRupee: false),
                        SummaryHeader(
                            title: "Total Amount", value: "${mData.total_amt}"),
                      ],
                      summaryHeader2: [
                        SummaryHeader(
                            title: "Charges", value: "${mData.charges_paid}"),
                        SummaryHeader(
                            title: "Commission", value: "${mData.comm_rec}"),
                        /*SummaryHeader(
                            title: "Aeps\n",
                            value: "${mData.aeps_no}",
                            isRupee: false),
                        SummaryHeader(
                            title: "M-ATM\n",
                            value: "${mData.matm_no}",
                            isRupee: false),
                        SummaryHeader(
                            title: "M-POS\n",
                            value: "${mData.mpos_no}",
                            isRupee: false),*/
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

            return _BuildListItem(list[index - 1], controller);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final AepsMatmReportController controller;
  final AepsReport report;

  const _BuildListItem(this.report, this.controller, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: (controller.tag == AppTag.aepsReportControllerTag ||
                controller.tag == AppTag.aadhaarPayReportControllerTag)
            ? report.aadhaarNumber.orNA()
            : report.mobileNumber.orNA(),
        subTitle: report.transactionType.orNA().toUpperCase() == "CW"
            ? "Cash Withdrawal"
            : "Balance Enquiry",
        date: "Date : " + report.transctionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        expandList: _titleValueWidget(),
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (report.transactionStatus!.toLowerCase() == "inprogress" ||
                    report.transactionStatus!.toLowerCase() == "pending" ||
                    kDebugMode)
                ? ReportActionButton(
                    title: "Re-query",
                    icon: Icons.refresh,
                    onClick: () {
                      controller.requeryTransaction(report);
                    },
                  )
                : const SizedBox(),
            const SizedBox(
              width: 8,
            ),
            ReportActionButton(
              title: "Print",
              icon: Icons.print,
              onClick: () {
                if (controller.tag == AppTag.aepsReportControllerTag) {
                  controller.printReceipt(
                      (report.transactionNumber ?? ""), ReceiptType.aeps);
                } else if (controller.tag ==
                    AppTag.aadhaarPayReportControllerTag) {
                  controller.printReceipt(
                      (report.transactionNumber ?? ""), ReceiptType.aadhaarPay);
                } else if (controller.tag == AppTag.mposReportControllerTag) {
                  controller.printReceipt(
                      (report.transactionNumber ?? ""), ReceiptType.mpos);
                } else {
                  controller.printReceipt(
                      (report.transactionNumber ?? ""), ReceiptType.matm);
                }
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
            //       "type":
            //           (controller.tag == AppTag.aadhaarPayReportControllerTag)
            //               ? "Aadhaar Pay"
            //               : "AEPS, MATM, MPOS"
            //     });
            //   },
            // )
          ],
        ),
      ),
    );
  }

  List<ListTitleValue> _titleValueWidget() {
    List<ListTitleValue> widgetList = [
      ListTitleValue(title: "Bank Name", value: report.bankName.toString()),
      ListTitleValue(
          title: "Transaction Id", value: report.transactionId.toString()),
      ListTitleValue(
          title: "Transaction No.", value: report.transactionNumber.toString()),
      ListTitleValue(title: "BC Id", value: report.bcid.toString()),
      ListTitleValue(title: "UTR", value: report.rrn.toString()),
      ListTitleValue(title: "Commission", value: report.commission.toString()),
      ListTitleValue(
          title: "Message", value: report.transactionMessage.toString()),
    ];
    if (controller.tag == AppTag.aepsReportControllerTag) {
      widgetList.add(ListTitleValue(
          title: "Mobile Number", value: report.mobileNumber.toString()));
    }

    return widgetList;
  }
}
