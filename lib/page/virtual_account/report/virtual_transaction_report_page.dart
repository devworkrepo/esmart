import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/virtual_account/virtual_report.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import '../../report/report_helper.dart';
import '../../report/report_search.dart';
import 'virtual_transaction_report_controller.dart';

class VirtualTransactionReportPage
    extends GetView<VirtualTransactionReportController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  const VirtualTransactionReportPage({Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VirtualTransactionReportController(controllerTag),
        tag: controllerTag);

    return Scaffold(
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
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(),
            label: const Text("Search")));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          isDateSearch:
              (controllerTag == AppTag.virtualAccountPendingTag) ? false : true,
          status: (controllerTag == AppTag.virtualAccountPendingTag)
              ? null
              : controller.searchStatus,
          statusList: (controllerTag == AppTag.virtualAccountPendingTag)
              ? null
              : ["All", "Accepted", "Pending", "Declined"],
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, _, status, __,___) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.searchStatus = status;
            AppUtil.logger("check search filter : $status");
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.reportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(
          bottom: 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(
              list[index],
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
  final VirtualTransactionReport report;
  final VirtualTransactionReportController controller;

  const _BuildListItem(this.report, {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: null,
        isExpanded: report.isExpanded,
        title: "V. A/C : " + report.van.orNA(),
        subTitle: "Mode  : " + report.mode.orNA(),
        date: "Date   : " + report.date.orNA(),
        amount: report.transactionAmount.toString(),
        status: report.status.toString(),
        statusId: ReportHelperWidget.getStatusId(report.status),
        expandList: [
          ListTitleValue(
              title: "Request Number", value: report.requestNumber.toString()),
          ListTitleValue(
              title: "Sender Name", value: report.remitterName.toString()),
          ListTitleValue(
              title: "IFSC Code", value: report.remitterIfscCode.toString()),
          ListTitleValue(
              title: "Account Number",
              value: report.remitterAccountNumber.toString()),
          ListTitleValue(title: "Mode", value: report.mode.toString()),
          ListTitleValue(
              title: "Utr Number", value: report.utrNumber.toString()),
          ListTitleValue(
              title: "Info",
              value: report.senderToReceiverInformation.toString()),
          ListTitleValue(
              title: "Remark", value: report.modifyRemark.toString()),
          ListTitleValue(
              title: "Added Date", value: report.addedDate.toString()),
          ListTitleValue(
              title: "Modified Date", value: report.modifyDate.toString()),
        ],
        actionWidget2: ((report.status ?? "").toLowerCase() == "pending")
            ? AppButton(
                text: "View & Accept",
                onClick: () => controller.fetchBond(report),
                width: 140,
                height: 40,
              )
            : null,
      ),
    );
  }
}
