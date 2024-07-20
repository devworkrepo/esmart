import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepAadhaarDetail extends GetView<SignupController> {
  const StepAadhaarDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify Your Aadhaar Details",
          style: Get.textTheme.headline6,
        ),
        Obx(() {
          var isFetched = controller.detailFetched.value;

          return (!isFetched)
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(top: 16),

                  decoration:
                      BoxDecoration(color: Colors.blue.withOpacity(0.1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                    height: 90,
                    width: 90,
                    margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all()),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: controller.aadhaarDetail.picname.toString(),
                      errorWidget: (context,value,value2){
                        return SizedBox(
                          height: 90,
                          width: 90,
                        );
                      },
                    ),
                  ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _TitleValueWidget(
                                title: "Name",
                                value: controller.aadhaarDetail.name ?? ""),
                            _TitleValueWidget(
                                title: "DOB",
                                value: controller.aadhaarDetail.dob ?? ""),
                            _TitleValueWidget(
                                title: "Gender",
                                value: controller.aadhaarDetail.gender ?? ""),
                            _TitleValueWidget(
                                title: "Aadhaar No.",
                                value: controller.aadhaarDetail.aadharno ?? ""),

                            _TitleValueWidget(
                                title: "Address",
                                value:
                                    controller.aadhaarDetail.address ?? ""),
                          ],
                        ),
                      )
                    ],
                  ),
                );
        }),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class _TitleValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const _TitleValueWidget({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(title,style: Get.textTheme.caption?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black
              ),),
              flex: 3,
            ),
            const Text("  :  "),
            Expanded(
                flex: 4,
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500,
                  color: Colors.black),
                )),
          ],
        ),
        Divider(indent: 0,color: Colors.grey[300],)
      ],
    );
  }
}
