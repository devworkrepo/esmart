import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:esmartbazaar/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:esmartbazaar/widget/common/report_action_button.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../../model/refund/dmt_refund.dart';
import '../../../model/refund/recharge.dart';
import '../../report/report_helper.dart';
import '../../report/report_search.dart';

class RechargeRefundPage extends GetView<RechargeRefundController> {

  final String origin;
  const RechargeRefundPage({required this.origin,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeRefundController());

    return Scaffold(
        appBar: (origin == "summary") ? AppBar(
          title: const Text("Utility Refund Pending"),
        ): null,
        body: Obx(() =>
            controller.reportResponseObs.value.when(onSuccess: (data) {
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
    var list = controller.reports;
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
            return _BuildListItem(list[index],origin);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<RechargeRefundController> {
  final RechargeRefund report;
  final String origin;
  const _BuildListItem(this.report, this.origin,{Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: "No : " + report.number.orNA(),
        subTitle: report.rechargeType.orNA().toUpperCase(),
        date: "Date : " + report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2: (origin == "summary") ? _refundButton(
            Get.theme.primaryColorDark,Colors.white
        ) : null,
        expandList: [
          ListTitleValue(
              title: "Transaction No.", value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Operator Name", value: report.operatorName.toString()),
          ListTitleValue(
              title: "Operator Ref No", value: report.operatorRefNumber.toString()),
          ListTitleValue(
              title: "Ref Mobile Number", value: report.refMobileNumber.toString()),
          ListTitleValue(
              title: "Pay Id",
              value: report.payId.toString()),

          ListTitleValue(
              title: "Message", value: report.transactionResponse.toString()),
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
            controller.takeRechargeRefund(value,report);
          },
        ),isScrollControlled: true);
      },);
  }
}
