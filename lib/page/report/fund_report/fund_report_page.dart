import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../../widget/common/report_action_button.dart';
import '../report_helper.dart';
import '../widget/summary_header.dart';
import 'fund_report_controller.dart';
import '../report_search.dart';

class FundRequestReportPage extends GetView<FundRequestReportController> {
  const FundRequestReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FundRequestReportController());
    return Scaffold(
        appBar: AppBar(
          title: Text((controller.isPendingRequest)
              ? "Fund Pending Report"
              : "Fund All Report"),
        ),
        body: Obx(() => controller.fundRequestReportResponseObs.value.when(
                onSuccess: (data) {
              if (data.code == 1) {
                if (data.moneyList!.isEmpty) {
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
        floatingActionButton: (!controller.shouldShowSummary)
            ? buildFloatingActionButton()
            : Obx(() {
                return (controller.reportList.isEmpty)
                    ? buildFloatingActionButton()
                    : const SizedBox();
              }));
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton.extended(
        icon: const Icon(Icons.search),
        onPressed: () => _onSearch(),
        label: const Text("Search"));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status:
              (controller.isPendingRequest) ? null : controller.searchStatus,
          statusList: (controller.isPendingRequest)
              ? null
              : const [

                  "Pending",
                  "Accepted",
                  "Reversed"
                ],
          inputFieldOneTile: "Request Number",
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            if (!controller.isPendingRequest) {
              controller.searchStatus = status;
            }
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.reportList;
    var count = list.length;
    if (controller.shouldShowSummary) {
      count = list.length + 1;
    }

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        margin: EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 0),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {
            if (controller.shouldShowSummary) {
              return setupItemForSummary(index, list);
            } else {
              return _BuildListItem(list[index]);
            }
          },
          itemCount: count,
        ),
      ),
    );
  }

  Widget setupItemForSummary(int index, RxList<FundRequestReport> list) {
    if (index == 0) {
      return Obx(() {
        var mData = controller.summaryReport.value!;
        return Column(
          children: [
            SummaryHeaderWidget(
              summaryHeader1: [
                SummaryHeader(
                    title: "Total\nRequests",
                    value: "${mData.total_count}",
                    isRupee: false),
                SummaryHeader(
                    title: "Total\nAmount", value: "${mData.total_amt}"),
                SummaryHeader(
                    title: "Cash/Cheque/\nFund Transfer",
                    value: "${mData.cash_tot}"),
              ],
              summaryHeader2: [
                SummaryHeader(
                    title: "IMPS/NEFT/\nRTGS", value: "${mData.imps_tot}"),
                SummaryHeader(title: "CDM Card\n", value: "${mData.cdm_tot}"),
                SummaryHeader(
                  title: "Online\nGateway",
                  value: "${mData.online_tot}",
                ),
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
    return _BuildListItem(list[index - 1]);
  }
}

class _BuildListItem extends GetView<FundRequestReportController> {
  final FundRequestReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
          txnNumber: null,
          isExpanded: report.isExpanded,
          title: report.referenceNumber.orNA(),
          subTitle: "Type : " + report.type.orNA(),
          date: "Date : " + report.addedDate.orNA(),
          amount: report.amount.toString(),
          status: report.status.toString(),
          statusId: ReportHelperWidget.getStatusId(report.status),
          expandList: getExpandList(),
          actionWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ((report.picName ?? "").isNotEmpty)
                  ? Container(
                      padding: EdgeInsets.only(top: 12),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            controller.onViewReceipt(report);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.remove_red_eye),
                              SizedBox(
                                width: 2,
                              ),
                              Text("Receipt")
                            ],
                          )),
                    )
                  : SizedBox(),
              SizedBox(
                width: 8,
              ),
              (report.status!.toLowerCase() == "incomplete" && controller.isPendingRequest)
                  ? Container(
                      padding: EdgeInsets.only(top: 12),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            controller.onUpdateClick(report);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.update),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Update")
                            ],
                          )),
                    )
                  : SizedBox(),
              // const SizedBox(
              //   width: 8,
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 12),
              //   child: ReportActionButton(
              //     title: "Complaint",
              //     icon: Icons.messenger_outline,
              //     onClick: () {
              //       controller.postNewComplaint({
              //         "transactionNumber": report.requestNumber.toString(),
              //         "type": "Money Requests"
              //       });
              //     },
              //   ),
              // )
            ],
          )),
    );
  }

  List<ListTitleValue> getExpandList() {
    var mList = [
      ListTitleValue(
          title: "Deposit Date", value: report.depositeDate.toString()),
      ListTitleValue(
          title: "Bank Name", value: report.bankAccountName.toString()),
      ListTitleValue(title: "Remark", value: report.remark.toString()),
      ListTitleValue(
          title: "Request Number", value: report.requestNumber.toString()),
      ListTitleValue(
          title: "Modified Remark", value: report.modifiedRemark.toString()),
    ];
    if (report.status != "Initiated") {
      mList.add(ListTitleValue(
          title: "Modified Date", value: report.modifiedDate.toString()));
    }
    return mList;
  }
}
