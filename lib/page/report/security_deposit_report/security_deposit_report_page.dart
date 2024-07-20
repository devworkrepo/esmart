import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/report/security_deposit.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../../model/report/wallet.dart';
import '../report_helper.dart';
import 'security_deposit_report_controller.dart';
import '../report_search.dart';

class SecurityDepositReportPage
    extends GetView<SecurityDepositReportController> {
  const SecurityDepositReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityDepositReportController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Security Deposit Report"),
        ),
        body: Obx(
            () => controller.reportResponseObs.value.when(onSuccess: (data) {
                  if (data.code == 1) {
                    if (data.translist == null || data.translist!.isEmpty) {
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
          status: controller.status,
          isMobileSearch: true,
          statusList: const [
            "All",
            "Created",
            "Pending",
            "Success",
            "Rejected",
            "Refunded"
          ],
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status, _,
              mobile) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.status = status;
            controller.mobileNumber = mobile;
            controller.transactionNumber = searchInput;
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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index]);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<SecurityDepositReportController> {
  final SecurityDepositReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        onTap: () => controller.onItemClick(report),
        child: AppExpandListWidget(
          txnNumber: null,
          isExpanded: report.isExpanded,
          title: report.first_name.orNA() + " " + report.first_name.orNA(),
          subTitle: "Email : " + report.email_id.orNA(),
          date: "Date : " + report.addeddate.orNA(),
          amount: report.amount.toString(),
          status: report.status.toString(),
          statusId: ReportHelperWidget.getStatusId(report.status),
          expandList: [
            ListTitleValue(
                title: "Date of Birth", value: report.dob.toString()),
            ListTitleValue(
                title: "Mobile No.", value: report.mobile_no.toString()),
            ListTitleValue(
                title: "Aadhaar No.", value: report.aadhar_no.toString()),
            ListTitleValue(title: "Pan No.", value: report.pan_no.toString()),
            ListTitleValue(title: "Remark", value: report.remark.toString()),
          ],
        ));
  }
}
