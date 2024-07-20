import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/progress.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/util/validator.dart';

import 'beneficiary_add_controller.dart';

class BeneficiaryAddPage extends GetView<BeneficiaryAddController> {
  const BeneficiaryAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BeneficiaryAddController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Beneficiary"),
      ),
      body: ObsResourceWidget(obs: controller.bankListResponseObs,childBuilder:(data)=> _buildSenderAddForm(),) /*Obx(
          () => controller.bankListResponseObs.value.when(onSuccess: (data) {
                if (data.code == 1) {
                  return _buildSenderAddForm();
                } else {
                  StatusDialog.failure(title: data.message)
                      .then((value) => Get.back());
                  return const SizedBox();
                }
              }, onFailure: (e) {
                return ExceptionPage(error: e);
              }, onInit: (data) {
                return AppProgressbar(
                  data: data,
                );
              }))*/,
    );
  }

  _buildSenderAddForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: controller.beneficiaryAddForm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MobileTextField(
                      enable: false,
                      controller: controller.mobileNumberController),
                  AppDropDown(
                    maxHeight: Get.height * 0.75,
                    list: List<String>.from(
                        controller.bankList.map((e) => e.bankName)),
                    onChange: (value) {
                     controller.onBankChange(value);
                    },
                    label: "Select Bank",
                    hint: "Required*",
                    validator: (value) {

                      AppUtil.logger(value);
                      const msg = "Select a bank first!";
                      if (value == null) {
                        return msg;
                      } else if (value.isEmpty) {
                        return msg;
                      } else {
                        return null;
                      }
                    },
                  ),
                  AppTextField(
                      hint: "Required*",
                      label: "IFSC Code",
                      maxLength: 11,
                      allCaps: true,
                      validator: (value) => FormValidatorHelper.normalValidation(
                          value,
                          minLength: 11),
                      controller: controller.ifscCodeController),
                  AppTextField(
                    hint: "Required*",
                    label: "Account Number",
                    maxLength: 20,
                    inputType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    validator: (value) =>
                        FormValidatorHelper.normalValidation(value, minLength: 8),
                    controller: controller.accountNumberController,
                    rightButton: (controller.isVerifying.value)
                        ? const CircularProgressIndicator()
                        : AppButton(
                            width: 76,
                            text: "Verify",
                            onClick: controller.verifyAccountNumber),
                  ),
                  AppTextField(
                      label: "Beneficiary Name",
                      hint: "Required*",
                      validator: (value) {
                        if (controller.validateBeneNameTextController) {
                          return FormValidatorHelper.normalValidation(value);
                        } else {
                          return null;
                        }
                      },
                      controller: controller.nameController),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                    text: "Proceed",
                    onClick: controller.onProceed,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
