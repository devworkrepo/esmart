import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/dmt_beneficiary_list_item.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/list/beneficiary_controller.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/list/beneficiary_list_item.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/list/sender_header.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/res/style.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/exception.dart';
import 'package:esmartbazaar/widget/api_component.dart';

import '../../../../widget/text_field.dart';

class UpiBeneficiaryListPage extends GetView<UpiBeneficiaryListController> {
  const UpiBeneficiaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiBeneficiaryListController());

    return Scaffold(
      body: Obx(
          () => controller.beneficiaryResponseObs.value.when(onSuccess: (data) {
                if (data.code == 1) {
                  return _buildBody();
                } else {
                  return ExceptionPage(
                      error: UnknownException(message: data.message));
                }
              }, onFailure: (e) {
                return ExceptionPage(error: e);
              }, onInit: (data) {
                return ApiProgress(data);
              })),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _buildSilverAppbar(),
            _buildSilverList(),
          ],
        ),
        Positioned(
            bottom: 1,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              width: Get.width,
              decoration: AppStyle.searchDecoration(
                  color: Get.theme.primaryColorDark.withOpacity(0.8), borderRadius: 2),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      onChange: controller.onSearchChange,
                    ),
                  ),
                  Column(children: [
                    FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        controller.addBeneficiary();
                      },
                      child:  Icon(Icons.add,color: Get.theme.primaryColorDark,),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                      child:  Text("Add New",style: TextStyle(color:Colors.white),),
                    )
                  ],)
                ],
              ),
            ))
      ],
    );
  }

  SliverAppBar _buildSilverAppbar() {
    return SliverAppBar(
      expandedHeight: 190,
      pinned: true,
      title: const Text("UPI Beneficiary List"),
      flexibleSpace: FlexibleSpaceBar(background: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UpiBeneficiarySenderHeader(
                mobileNumber: controller.sender?.senderNumber ?? "",
                senderName: controller.sender?.senderName ?? "",
                limit: controller.sender?.impsNKycLimitView ?? "",
                onClick: () {
                  Get.toNamed(AppRoute.dmtBeneficiaryAddPage, arguments: {
                    "mobile": controller.sender!.senderNumber!,
                  })?.then((value) {
                    if (value != null) {
                      if (value) {
                        controller.fetchBeneficiary();
                      }
                    }
                  });
                },
              ),
            ],
          );
        },
      )),
    );
  }

  SliverList _buildSilverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {
          return Obx(() {

            if (controller.beneficiaryListObs.isEmpty) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "No beneficiary found!",
                  style: Get.textTheme.headline3,
                ),
              ));
            } else {
              var bottomPadding = 1.0;
              if (index == controller.beneficiaryListObs.length - 1) {
                bottomPadding = 120.0;
              }

              return Padding(
                padding: EdgeInsets.only(
                    left: 7, right: 7, bottom: bottomPadding, top: 1),
                child: UpiBeneficiaryListItem(index),
              );
            }
          });
        },
        childCount: (controller.beneficiaryListObs.isEmpty)
            ? 1
            : controller.beneficiaryListObs.length,
      ),
    );
  }
}
