
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/investment/investment_withdrawn.dart';
import 'package:esmartbazaar/model/report/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/report/receipt_print_mixin.dart';
import 'package:esmartbazaar/page/report/report_search2.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

import 'package:esmartbazaar/widget/common/report_action_button.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/page/report/report_search.dart';
import 'investment_withdrawn_controller.dart';

class InvestmentWithdrawnPage extends GetView<InvestmentWithdrawnController> {
  const InvestmentWithdrawnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentWithdrawnController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Investment Withdrawal List"),
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
        CommonReportSearchDialog2(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: controller.searchStatus,
          inputFieldOneTile: "Transaction Number",
          inputFieldTwoTile: "Investment Number",
          onSubmit:
              (fromDate, toDate, searchInput,searchInput2, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.searchInput2 = searchInput2;
            controller.searchStatus = status;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody(InvestmentWithdrawnListResponse data) {
    var list = data.reports!;
    var count = list.length;
    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemBuilder: (context, index) {
          return _BuildListItem(
            list[index],
          );
        },
        itemCount: count,
      ),
    );
  }
}

class _BuildListItem extends GetView<InvestmentWithdrawnController> {
  final InvestmentWithdrawnListItem report;

  const _BuildListItem(this.report, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: Card(
        child: AppExpandListWidget(
          txnNumber: null,
          isExpanded: report.isExpanded,
          showDivider: false,
          titleHeader: "Investment Number",
          title: report.fd_refno.orNA(),
          subTitleHeader: "Bank Detail",
          subTitle:  report.acc_name.orNA() + "-"+report.acc_no.toString(),
          date: "Date : " + report.addeddate.orNA(),
          amount: report.amount.toString(),
          status: report.trans_status.toString(),
          statusId: ReportHelperWidget.getStatusId(report.trans_status),
          expandList: [

            ListTitleValue(
                title: "Transaction No.", value: report.trans_no.toString()),
            ListTitleValue(
                title: "Bank Name",
                value: report.acc_name.toString()),
            ListTitleValue(title: "Account No.", value: report.acc_no.toString()),
            ListTitleValue(title: "Charge", value:AppConstant.rupeeSymbol + report.charge.toString()),
            ListTitleValue(title: "UTR", value:report.utr_no.toString()),
            ListTitleValue(title: "Response", value: report.trans_response.toString()),
            ListTitleValue(
                title: "Remark",
                value: report.remark.toString()),

          ],
        ),
      ),
    );
  }
}
