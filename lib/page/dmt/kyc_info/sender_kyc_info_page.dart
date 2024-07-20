import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/page/dmt/kyc_info/sender_kyc_info_controller.dart';
import 'package:esmartbazaar/page/dmt/sender_kcy/sender_kyc_controller.dart';
import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../route/route_name.dart';

class SenderKycInfoPage extends GetView<SenderKycInfoController> {
  const SenderKycInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderKycInfoController());
    return WillPopScope(
      onWillPop: () async{
        if(controller.fromKyc){
           Get.offAllNamed(AppRoute.mainPage);
           return  false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Sender Kyc Info"),),
        body: ObsResourceWidget(
            obs: controller.responseObs,
            childBuilder: (data) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kyc Detail",
                      style: Get.textTheme.headline1?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            AppNetworkImage(
                              controller.kycInfoResponse.picName.toString(),
                              size: 120,
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            _BuildTitleValueWidget(
                                title: "Name",
                                value:  controller.kycInfoResponse.name.toString()),
                            _BuildTitleValueWidget(
                                title: "Date of Birth",
                                value:  controller.kycInfoResponse.dob.toString()),
                            _BuildTitleValueWidget(
                                title: "Gender",
                                value:
                                ( controller.kycInfoResponse.gender.toString() == "M")
                                    ? "Male"
                                    : "Female"),
                            _BuildTitleValueWidget(
                                title: "Aadhaar Number",
                                value:
                                controller.kycInfoResponse.aadhaarNumber.toString()),
                            _BuildTitleValueWidget(
                                title: "Address",
                                value:  controller.kycInfoResponse.address.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _BuildTitleValueWidget extends StatelessWidget {
  final String title;
  final String? value;
  const _BuildTitleValueWidget({required this.title,required this.value,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          BuildTitleValueWidget(
            title: title,
            value: value ?? "",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),

          Divider(indent: 0,color: Colors.grey[400],)
        ],
      ),
    );
  }
}
