import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/api_component.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';

import '../../../model/statement/credit_debit_statement.dart';
import '../../report/report_search.dart';
import 'credit_debit_controller.dart';

class CreditDebitPage extends GetView<CreditDebitController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  const CreditDebitPage({Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreditDebitController(controllerTag), tag: controllerTag);
    return Scaffold(
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
          inputFieldOneTile: "Ref Number",
          statusList: const ["All","Success","Failed","Queued"],
          status: controller.status,
          serviceType: controller.getServiceType(),
          serviceTypeList: const ["All","Credit","Debit"],
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,serviceType,_) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.status = status;
            controller.setServiceType(serviceType);
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
          padding: const EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(
              list[index],
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<CreditDebitController> {
  final CreditDebitStatement report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.date.toString(),
                        style: Get.textTheme.bodyText1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Ref No : " + report.refno.toString(),
                        style: Get.textTheme.subtitle2,
                      ),
                    ],
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    children: [
                      Text(
                        "Amount",
                        style: Get.textTheme.subtitle2
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Text(
                        "Rs. ${report.getAmount()}",
                        style: Get.textTheme.subtitle1?.copyWith(color: report.getColor()),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 16,),
              BuildTitleValueWidget(title: "Ref No", value: report.refno!),
              BuildTitleValueWidget(title: "Remark", value: report.remark!),
              BuildTitleValueWidget(title: "Narration", value: report.narration!),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
