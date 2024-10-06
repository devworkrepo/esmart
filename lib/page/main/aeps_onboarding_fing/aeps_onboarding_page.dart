import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../../util/validator.dart';
import '../../../widget/drop_down.dart';
import '../../../util/input_validator.dart';
import 'aeps_onbording_controller.dart';

class AepsOnboadingFingPage extends GetView<AepsOnboardingFingController> {
  const AepsOnboadingFingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsOnboardingFingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps -2 Onboarding"),
      ),
      body:  ObsResourceWidget(
              obs: controller.stateListResponseObs,
              childBuilder: (data) => _buildBody(),
            )
    );
  }

  Padding _buildBody() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [_BuildFormWidget()],
        ),
      ),
    );
  }
}

class _BuildFormWidget extends GetView<AepsOnboardingFingController> {
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

                    AppTextField(
                      controller: controller.uploadPanController,
                      prefixIcon: Icons.file_copy_outlined,
                      label: "Pan Image",
                      validator: (value)=>(controller.selectedPanImageFile ==null) ? "Select Aadhaar Image" : null,
                      hint: "",
                      onFieldTab: () =>
                          controller.showImagePickerBottomSheetDialog(FingOnboardingDocType.pan),
                    ),

                  AppTextField(
                    controller: controller.uploadIdController,
                    prefixIcon: Icons.file_copy_outlined,
                    label: "Cancel Cheque Image",
                    validator: (value)=>(controller.selectedIdImageFile ==null) ? "Select Cancel Cheque Image" : null,
                    hint: "",
                    onFieldTab: () =>
                        controller.showImagePickerBottomSheetDialog(FingOnboardingDocType.id),
                  ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(12),
                      child: Obx(()=>Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(controller.longitude.value.isNotEmpty)  Text(
                            "Location : ${controller.latitude} - ${controller.longitude}",
                            style: Get.textTheme.bodyMedium?.copyWith(),
                          ),
                          const SizedBox(height: 8,),
                         if(controller.longitude.value.isEmpty)
                           Text("Fetching Location...",style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),),

                        ],
                      )),
                    ),

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

                  AppTextField(
                    controller: controller.panController,
                    label: "Pan Number",
                    hint: "10 characters pan number",
                    maxLength: 10,
                    validator: (value) => FormValidatorHelper.isValidPanCardNo(value),
                  ),


                  AppTextField(
                    hint: "Required*",
                    label: "Account Number",
                    maxLength: 20,
                    inputType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    validator: (value) =>
                        FormValidatorHelper.normalValidation(value, minLength: 8),
                    controller: controller.accountController,

                  ),
                  AppTextField(
                      label: "Account Holder Name",
                      hint: "Required*",
                      validator: (value) => FormValidatorHelper.normalValidation(value),
                      controller: controller.nameController),

                  AppTextField(
                      label: "Bank Name",
                      hint: "Required*",
                      validator: (value) => FormValidatorHelper.normalValidation(value),
                      controller: controller.bankNameController),
                  AppTextField(
                      hint: "Required*",
                      label: "IFSC Code",
                      maxLength: 11,
                      allCaps: true,
                      validator: (value) => FormValidatorHelper.normalValidation(
                          value,
                          minLength: 11),
                      controller: controller.ifscController),
                  AppTextField(
                      label: "Branch Name",
                      hint: "Required*",
                      validator: (value) => FormValidatorHelper.normalValidation(value),
                      controller: controller.branchNameController),
                  AppTextField(
                      label: "Pin Code",
                      hint: "Required*",
                      maxLength: 6,
                      inputType: TextInputType.number,
                      validator: (value) => FormValidatorHelper.pincode(value),
                      controller: controller.pinCodeController),
                  AppTextField(
                      label: "City Name",
                      hint: "Required*",
                      validator: (value) => FormValidatorHelper.normalValidation(value),
                      controller: controller.cityNameController),

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
