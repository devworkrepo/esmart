import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/date_util.dart';
import 'package:esmartbazaar/util/validator.dart';

import 'add_bank_controller.dart';

class SettlementBankAddPage extends GetView<SettlementBankAddController> {
  const SettlementBankAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SettlementBankAddController());
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: const [
                _SettlementBankAddFormWidget(),
              ],
            ),
          )),
          AppButton(
              text: "Add Bank",
              onClick: () {
                controller.onAddButtonClick();
              })
        ],
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: const Text("Add Settlement Bank"),
    );
  }
}

class _SettlementBankAddFormWidget
    extends GetView<SettlementBankAddController> {
  const _SettlementBankAddFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: controller.bankNameController,
                  label: "Bank Name",
                  validator: FormValidatorHelper.normalValidation,
                ),
                AppTextField(
                  controller: controller.accountHolderController,
                  label: "Account Holder Name",
                  validator: FormValidatorHelper.normalValidation,
                ),
                AppTextField(
                  controller: controller.accountController,
                  maxLength: 20,
                  inputType: TextInputType.number,
                  label: "Account Number",
                  validator: (value) {
                    if (value!.length > 5 && value.length < 21) {
                      return null;
                    } else {
                      return "Enter 6 - 20 digits account number";
                    }
                  },
                ),
                AppTextField(
                  controller: controller.ifscController,
                  maxLength: 11,
                  label: "IFSC Code",
                  allCaps: true,
                  validator: (value) {
                    if (value!.length == 11) {
                      return null;
                    } else {
                      return "Enter 11 digits IFSc Code";
                    }
                  },
                ),
                AppTextField(
                  controller: controller.uploadSlipController,
                  prefixIcon: Icons.file_copy_outlined,
                  label: "Upload Cancel Cheque",
                  hint: "Required*",
                  onFieldTab: () =>
                      controller.showImagePickerBottomSheetDialog(),
                  validator: (value) {
                    return FormValidatorHelper.empty(value);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
