import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/data/repo/dmt_repo.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/page/exception_page.dart';

class SenderChangeNameController extends GetxController {

  DmtRepo repo = Get.find<DmtRepoImpl>();
  SenderInfo senderInfo = Get.arguments["sender"];

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  onNameChange() async {
    if (!formKey.currentState!.validate()) return;
    var firstName = firstNameController.text.toString();
    var lastName = lastNameController.text.toString();

    try {
      StatusDialog.progress();
      var response = await repo.changeSenderName({
        "first_name": firstName,
        "last_name": lastName,
        "remitterid": senderInfo.senderId.toString(),
        "remitter_mobile": senderInfo.senderNumber.toString(),
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) =>
            Get.back(result:  firstName+" "+lastName));
      }
      else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
