import 'package:esmartbazaar/page/dmt_upi/beneficiary/add/qr_view.dart';
import 'package:esmartbazaar/page/dmt_upi/scan_pay/upi_scan_controller.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt_upi/search_sender/search_sender_controller.dart';
import 'package:esmartbazaar/widget/radio.dart';

import '../../../widget/button.dart';

class UpiScanPayPage extends GetView<UpiScanAndPayController> {
  const UpiScanPayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiScanAndPayController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan And Pay"),
      ),
      body: Obx(() =>
      (controller.qrResultObs["isScanned"] == false)
          ? const SizedBox()
          :  SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
            child:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: controller.formKey,
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
                                controller
                                    .qrResultObs["name"]
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700]!,
                                    fontSize: 20),
                              ),
                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                controller
                                    .qrResultObs["upiId"]
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [
                            GestureDetector(
                              onTap: ()=>Get.to(()=>const QRCodeScannerPage())?.then((value) => controller.onScanResult(value)),
                              child: Card(
                                  color: Get.theme.primaryColorDark,
                                  elevation: 8,
                                  shape: const CircleBorder(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      "assets/image/qr_code.png",
                                      height: 24,
                                      color: Colors.white,
                                    ),
                                  )),
                            ),
                            const Text(
                              "Scan QR",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey[300],
                      indent: 0,
                    ),

                    AmountTextField(controller: controller.amountController,
                    validator:(value)=> controller.amountValidation(value),),


                    MPinTextField(controller: controller.mpinController),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(children: [

                      const SizedBox(width: 8,),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                            text: "Proceed Transaction",
                            onClick: () => controller.proceedTransaction()),
                      )
                    ],)
                  ],
                ),
              ),
            ),
                  ),
          ))),
    );
  }
}
