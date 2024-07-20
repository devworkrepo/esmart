import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/dmt/sender_change/change_name/sender_change_name_controller.dart';
import 'package:esmartbazaar/util/validator.dart';

class SenderNameChangePage extends StatelessWidget {
  const SenderNameChangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderChangeNameController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Sender Name"),
      ),
      body: const SingleChildScrollView(
        child: _ChangeNameForm(),
      ),
    );
  }
}

class _ChangeNameForm extends GetView<SenderChangeNameController> {
  const _ChangeNameForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: controller.firstNameController,
                        label: "First Name",
                        hint: "Enter First Name",
                        validator: FormValidatorHelper.normalValidation,
                      ),
                      AppTextField(
                        controller: controller.lastNameController,
                        label: "Last Name",
                        hint: "Enter Last Name",
                        validator: FormValidatorHelper.normalValidation,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(text: "Change Name", onClick: ()=>controller.onNameChange()),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
