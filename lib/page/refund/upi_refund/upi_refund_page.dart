import 'package:esmartbazaar/page/refund/upi_refund/upi_refund_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/common/report_action_button.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import '../../../model/refund/dmt_refund.dart';
import '../../report/report_helper.dart';
import '../../report/report_search.dart';

class UpiRefundPage extends GetView<UpiRefundController> {
  final String origin;

  const UpiRefundPage(
      {Key? key, required this.origin})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(UpiRefundController());

    return Scaffold(
        appBar: (origin == "summary") ? AppBar(
          title:  const Text("UPI Refund Pending"),
              ): null,
        body: Obx(() =>
            controller.moneyReportResponseObs.value.when(onSuccess: (data) {
              if (data.code == 1) {
                if (data.list!.isEmpty) {
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
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,_,__) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.moneyReportList;
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
          padding: const EdgeInsets.only(top: 0),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index], controller,origin);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final DmtRefund report;
  final UpiRefundController controller;
  final String origin;

  const _BuildListItem(this.report, this.controller,this.origin, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: "" + report.accountNumber.orNA(),
        subTitle: report.beneficiaryName.orNA(),
        date: "Date : " + report.transactionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2:(origin == "summary") ? _refundButton(
            Get.theme.primaryColorDark,Colors.white
        ) : null,
        expandList: [
          ListTitleValue(
              title: "Remitter Number", value: report.senderNumber.toString()),
          ListTitleValue(
              title: "Transaction No.",
              value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Beneficary Name",
              value: report.beneficiaryName.toString()),
          ListTitleValue(
              title: "Account Number", value: report.accountNumber.toString()),
          ListTitleValue(
              title: "Transaction Type",
              value: report.transactionType.toString()),
          ListTitleValue(
              title: "Commission", value: report.commission.toString()),
          ListTitleValue(
              title: "UTR Number", value: report.utrNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionMessage.toString()),
        ],
        actionWidget: _refundButton(Colors.white, Colors.black),
      ),
    );
  }

  ReportActionButton _refundButton(Color background, Color color) {
    return ReportActionButton(
      title: "Take Refund",
      icon: Icons.keyboard_return,
      background: background,
      color: color,
      onClick: (){
        Get.bottomSheet(RefundBottomSheetDialog(
          onProceed: (value){
            controller.takeDmtRefund(value,report);
          },
        ),isScrollControlled: true);
      },);
  }
}
