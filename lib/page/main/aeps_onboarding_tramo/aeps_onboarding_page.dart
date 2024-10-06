import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../widget/drop_down.dart';
import '../../../util/input_validator.dart';
import 'aeps_onbording_controller.dart';

class AepsOnboardingPage extends GetView<AepsOnboardingController> {
  const AepsOnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsOnboardingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Onboarding"),
      ),
      body: (controller.isApesTramo)
          ? ObsResourceWidget(
              obs: controller.stateListResponseObs,
              childBuilder: (data) => _buildBody(),
            )
          : _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: const [_BuildFormWidget()],
        ),
      ),
    );
  }
}

class _BuildFormWidget extends GetView<AepsOnboardingController> {
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fill Form",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  if (!controller.isApesTramo)
                    AppTextField(
                      controller: controller.uploadSlipController,
                      prefixIcon: Icons.file_copy_outlined,
                      label: "Aadhaar Image",
                      validator: (value)=>(controller.selectedImageFile ==null) ? "Select aadhaar image" : null,
                      hint: "",
                      onFieldTab: () =>
                          controller.showImagePickerBottomSheetDialog(),
                    ),
                  if (!controller.isApesTramo)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12),
                      child: Obx(()=>Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location",
                            style: Get.textTheme.headline6?.copyWith(),
                          ),
                          const SizedBox(height: 8,),
                         if(controller.longitude.value.isEmpty)
                           Text("Fetching...",style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),),
                         if(controller.longitude.value.isNotEmpty) Text(
                            "Latitude : ${controller.latitude}",
                            style: Get.textTheme.caption
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        if(controller.longitude.value.isNotEmpty)  Text(
                            "Latitude : ${controller.longitude}",
                            style: Get.textTheme.caption
                                ?.copyWith(fontWeight: FontWeight.w500),
                          )
                        ],
                      )),
                    ),
                  if (controller.isApesTramo)
                    AppTextField(
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          AadhaarInputValidator()
                        ],
                        maxLength: 14,
                        hint: "Aadhaar number",
                        label: "Aadhaar Number",
                        validator: (value) {
                          if (value!.length == 14) {
                            return null;
                          } else {
                            return "Enter 12 digits aadhaar number";
                          }
                        },
                        controller: controller.aadhaarController),
                  if (controller.isApesTramo)
                    AppDropDown(
                      maxHeight: Get.height * 0.75,
                      list: List.from(
                          controller.aepsStateList.map((e) => e.name)),
                      onChange: (value) {
                        try {
                          controller.selectedState = controller.aepsStateList
                              .firstWhere((element) => element.name == value);
                        } catch (e) {
                          controller.selectedState = null;
                          Get.snackbar("State is not selected",
                              "Exception raised while selecting state",
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        }
                      },
                      validator: (value) {
                        if (controller.selectedState == null) {
                          return "Select State";
                        } else {
                          return null;
                        }
                      },
                      searchMode: true,
                      label: "Select State",
                      hint: "Select State",
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(text: "Proceed", onClick: controller.onProceed)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
