import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/widget/check_box.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/list_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/add/beneficiary_add_controller.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/add/qr_view.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../util/api/exception.dart';
import '../../../../widget/api_component.dart';
import '../../../../widget/button.dart';
import '../../../exception_page.dart';

class UpiBeneficiaryAddPage extends GetView<UpiBeneficiaryAddController> {
  const UpiBeneficiaryAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiBeneficiaryAddController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Upi Id"),
      ),
      body: Obx(
          () => controller.upiBankListResponseObs.value.when(onSuccess: (data) {
                if (data.code == 1) {
                  return _abc();
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

  _abc() {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildTabOption(AddQRTab.addUpiId),
                _buildTabOption(AddQRTab.addUpiIdLinkedMobile),
                _buildTabOption(AddQRTab.scanQR)
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(8),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
            child: (controller.selectedTab.value == AddQRTab.addUpiId)
                ? _buildAddUPIFormWidget()
                : (controller.selectedTab.value ==
                        AddQRTab.addUpiIdLinkedMobile)
                    ? _buildAddUPILinkedWidgetWidget()
                    : _buildQRScanWidget(),
          ))
        ],
      ),
    );
  }

  _buildTabOption(AddQRTab tab) {
    var isSelected = controller.selectedTab.value == tab;

    var color = (isSelected) ? Colors.white : Colors.grey[700];
    var background =
        (isSelected) ? Get.theme.primaryColorDark : Colors.grey[100];
    return Expanded(
        child: GestureDetector(
      onTap: () => controller.onTabClick(tab),
      child: Container(
        margin: const EdgeInsets.all(1),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1),
            color: background,
            border:
                Border.all(color: Colors.grey, width: (isSelected) ? 1 : 1)),
        child: Text(
          controller.getTabTitle(tab),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ));
  }

  _buildAddUPIFormWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: PaymentMethod.values.map((method) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Obx(() => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio<PaymentMethod>(
                                  value: method,
                                  groupValue: controller.selectedMethod.value,
                                  onChanged: (PaymentMethod? value) {
                                    if (value != null) {
                                      controller.selectedMethod.value = value;
                                    }
                                  },
                                ),
                                Image.asset(
                                  controller.getUpiSelectedIcon(method),
                                  height: 16,
                                  fit: BoxFit.fitHeight,
                                ),
                              ],
                            )),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        AppTextField(
                            hint: "required",
                            label: "Upi Id without @",
                            validator: (value) =>
                                FormValidatorHelper.normalValidation(value,
                                    minLength: 10),
                            controller: controller.upiIdController),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(() => AppDropDown(
                            label: "Upi Extension",
                            list: controller.selectedUpiList
                                .map((e) => e.upi_name!)
                                .toList(),
                            selectedItem:
                                controller.selectedUpiList.first.upi_name,
                            onChange: (value) =>
                                controller.onBankSelect(value))),
                        const SizedBox(
                          height: 5,
                        ),
                        if (controller.isVerify.value)
                          Column(
                            children: [
                              const Text(
                                "Verified Beneficiary Name",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                controller.verifiedDetail["name"].toString(),
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        if (false)
                          AppTextField(
                            hint: "required",
                            label: "Upi Name",
                            validator: FormValidatorHelper.normalValidation,
                            controller: controller.upiNameController,
                          ),
                        const SizedBox(
                          height: 24,
                        ),
                        (!controller.isVerify.value)
                            ? AppButton(
                                text: "Verify Upi Id",
                                onClick: () => controller.verifyUpiId(),
                                background: Colors.green,
                              )
                            : AppButton(
                                text: "Add Upi Id",
                                onClick: () => controller.addBeneficiary())
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildAddUPILinkedWidgetWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: controller.formKeyAddUpiLinkedMobile,
                    child: Column(
                      children: [
                        AppTextField(
                          hint: "required",
                          label: "Enter UPI Mobile No",
                          inputType: TextInputType.number,
                          maxLength: 10,
                          validator: FormValidatorHelper.mobileNumberValidation,
                          controller: controller.mobileController,
                          rightButton: AppButton(
                              width: 100,
                              text: "Verify",
                              background: Colors.green,
                              onClick: () {
                                controller.searchMobile();
                              }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (controller.searchResultObs.value?.upiList != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Verified Beneficiary Name",
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(" : "),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      controller
                                          .searchResultObs.value!.bene_name
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700]!,
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Primary UPI Id",
                                      style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 12),
                                    ),
                                  ),
                                  Text(" : "),
                                  Expanded(
                                    child: Text(
                                      controller
                                          .searchResultObs.value!.primary_vpa
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                          fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey[300],
                                indent: 0,
                              ),
                              if (controller
                                  .searchResultObs.value!.upiList!.isNotEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Additional Linked UPI IDs",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              if (controller
                                  .searchResultObs.value!.upiList!.isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[300]!)),
                                  child: Column(
                                    children: [
                                      ...controller
                                          .searchResultObs.value!.upiList!
                                          .map((e) {
                                        return AppCheckBox(
                                            value: e.isSelected,
                                            onChange: (value) {
                                              e.isSelected = value;
                                            },
                                            title: e.vpa_name.toString());
                                      })
                                    ],
                                  ),
                                ),
                              const SizedBox(
                                height: 24,
                              ),
                              AppButton(
                                  text: "Add Upi Ids",
                                  onClick: () => controller.addBeneficiaries())
                            ],
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildQRScanWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.qrResultObs["isScanned"] == true)
              Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "UPI Name",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.qrResultObs["name"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: (controller.qrResultObs["isVerified"] ==
                                              true)
                                          ? Colors.green[700]!
                                          : Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                              Icon(Icons.verified,size: 16,color: (controller.qrResultObs["isVerified"] ==
                                  true)
                                  ? Colors.green[700]!
                                  : Colors.black,)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Divider(
                              color: Colors.grey[300],
                              indent: 0,
                            ),
                          ),
                          Text(
                            "UPI Id",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                         Row(children: [
                           Expanded(
                             child: Text(
                               controller.qrResultObs["upiId"].toString(),
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: (controller.qrResultObs["isVerified"] ==
                                       true)
                                       ? Colors.green[700]!
                                       : Colors.black,
                                   fontSize: 14),
                             ),
                           ),
                           Icon(Icons.verified,size: 16,color: (controller.qrResultObs["isVerified"] ==
                               true)
                               ? Colors.green[700]!
                               : Colors.black,)
                         ],),
                        ],
                      )),
                  const SizedBox(
                    height: 24,
                  ),
                  (controller.qrResultObs["isVerified"] == true)
                      ? AppButton(
                          text: "Add Upi Id",
                          onClick: () => controller.addQRUpiId())
                      : AppButton(
                          text: "Verify Upi Id",
                          background: Colors.green,
                          onClick: () => controller.verifyQRUpiId()),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {
                Get.to(()=>const QRCodeScannerPage())?.then((value) {
                  if(value!=null){
                    controller.qrResultObs.value = {
                      "isVerified" : false,
                      "isScanned" : true,
                      "name" : value["name"],
                      "upiId" : value["upiId"],
                    };
                  }
                });
              },
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
              "Scan QR Code",
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class CircularImageButton extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onTap;

  const CircularImageButton(
      {super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
            image: image,
            width: 30.0,
            height: 30.0,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
