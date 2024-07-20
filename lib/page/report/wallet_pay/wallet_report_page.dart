import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

import '../../../model/report/wallet.dart';
import '../report_helper.dart';
import '../widget/summary_header.dart';
import 'wallet_report_controller.dart';
import '../report_search.dart';

class WalletPayReportPage extends GetView<WalletPayReportController> {
  const WalletPayReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WalletPayReportController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Pay Report"),
      ),
      body: Obx(() =>
          controller.reportResponseObs.value.when(onSuccess: (data) {
            if (data.code == 1) {
              if(data.reports!.isEmpty){
                return const NoItemFoundWidget();
              }
              else {
               return  _buildListBody();
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
        })
    );
  }

  _onSearch() {
    Get.bottomSheet(CommonReportSearchDialog(
      fromDate: controller.fromDate,
      toDate: controller.toDate,
      onSubmit: (fromDate, toDate, searchInput,searchInputType, status,_,__) {
        controller.fromDate = fromDate;
        controller.toDate = toDate;
        controller.onSearch();
      },
    ),isScrollControlled: true);
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
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0,bottom: 100),
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
                          isRupee: false
                            ),
                        SummaryHeader(
                            title: "Total\nAmount",
                            value: "${mData.total_amt}",
                            ),
                        SummaryHeader(
                            title: "Charges\nPaid",
                            value: "${mData.charge_paid}",
                            ),

                      ],
                      summaryHeader2: [
                        SummaryHeader(
                          title: "Amount Transferred",
                          value: "${mData.amt_trf}",
                        ),
                        SummaryHeader(
                            title: "Amount Received",
                            value: "${mData.amt_rec}",
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

            return _BuildListItem(
              list[index - 1],
            );
        },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends GetView<WalletPayReportController> {
  final WalletPayReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: null,
        isExpanded: report.isExpanded,
        title: "Received By : "+report.receivedBy.orNA(),
        subTitle:"Ref : "+ report.refNumber.orNA(),
        date: "Date : "+report.date.orNA(),
        amount: report.amount.toString(),
        status: report.payStatus.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.payStatus),


        expandList: [
          ListTitleValue(title: "Paid By", value: report.paidBy.toString()),
          ListTitleValue(title: "Message", value: report.payMessage.toString()),
          ListTitleValue(title: "Remark", value: report.remark.toString()),

        ],)
    );
  }


}
