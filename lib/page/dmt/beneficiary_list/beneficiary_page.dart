import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/beneficiary_controller.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/dmt_beneficiary_list_item.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/sender_header.dart';
import 'package:esmartbazaar/page/dmt/beneficiary_list/component/sender_kyc_dialog.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/res/style.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/exception.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/api_component.dart';

import '../../../widget/text_field.dart';

class BeneficiaryListPage extends GetView<BeneficiaryListController> {
  const BeneficiaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BeneficiaryListController());

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
              }))
      /*Obx(() => controller.beneficiaryResponseObs.value.when(
          onSuccess: (data) => _buildBody(),
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => AppProgressbar(
                data: data,
              )))*/
      ,
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
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              width: Get.width,
              decoration: AppStyle.searchDecoration(
                  color: Colors.black38, borderRadius: 2),
              child: Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      onChange: controller.onSearchChange,
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      controller.addBeneficiary();
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
            ))
        /* Container(
          color: Colors.black12,
          margin: const EdgeInsets.all(8),
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: AppSearchField(
                  onChange: controller.onSearchChange,
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  controller.addBeneficiary();
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        )*/
      ],
    );
  }

  SliverAppBar _buildSilverAppbar() {
    return SliverAppBar(
      actions: [
        PopupMenuButton<BeneficiaryListPopMenu>(
          onSelected: (i) => controller.onSelectPopupMenu(i),
          itemBuilder: (BuildContext context) {
            return controller
                .popupMenuList()
                .map((BeneficiaryListPopMenu choice) {
              return PopupMenuItem<BeneficiaryListPopMenu>(
                value: choice,
                child: Row(
                  children: [
                    Icon(
                      choice.icon,
                      size: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(choice.title)
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
      expandedHeight: (controller.sender!.showNonKycDetail == true) ? 270 : 190,
      pinned: true,
      title: const Text("Beneficiary List"),
      flexibleSpace: FlexibleSpaceBar(background: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BeneficiarySenderHeader(
                mobileNumber: controller.sender?.senderNumber ?? "",
                senderName: controller.sender?.senderName ?? "",
                limit: controller.sender?.impsNKycLimitView ?? "",
                onClick: () {
                  Get.toNamed(AppRoute.dmtBeneficiaryAddPage, arguments: {
                    "mobile": controller.sender!.senderNumber!,
                    "dmtType": controller.dmtType
                  })?.then((value) {
                    if (value != null) {
                      if (value) {
                        controller.fetchBeneficiary();
                      }
                    }
                  });
                },
              ),
              (controller.sender!.showNonKycDetail == true)
                  ? Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.blue),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "You can get monthly sender limit upto 2 Lac by doing EKYC of Customer.",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          /*Get.dialog(SenderKycDialog((aadhaarNumber) {
                                  Get.back();
                                  Get.toNamed(AppRoute
                                          .dmtEkycPage)
                                      ?.then((value) {
                                    if (value != null) {
                                      if (value is Map) {
                                        var isCompleted =
                                            value["isEkycCompleted"];
                                        if (isCompleted) {
                                          Get.back(result: {
                                            "mobile_number":
                                                controller.sender!.senderNumber,
                                          });
                                        }
                                      }
                                    }
                                  });
                                }));
*/
                          Get.toNamed(AppRoute.senderKycPage, arguments: {
                            "dmt_type": controller.dmtType,
                            "mobile_number":
                            controller.sender!.senderNumber!
                          });
                        },
                        child: const Text("Do Kyc"))
                  ],
                ),
              )
                  : const SizedBox()
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
            controller.beneficiaryListObs.value;
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
              if (index == controller.beneficiaryListObs.value.length - 1) {
                bottomPadding = 120.0;
              }

              return Padding(
                padding: EdgeInsets.only(
                    left: 7, right: 7, bottom: bottomPadding, top: 1),
                child: DmtBeneficiaryListItem(index),
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
