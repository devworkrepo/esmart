import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/complain_repo.dart';
import 'package:esmartbazaar/data/repo_impl/complain_repo_impl.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class ComplainPostController extends GetxController {
  final ComplainRepo repo = Get.find<ComplainRepoImpl>();
  final formKey = GlobalKey<FormState>();
  final transactionNumberController = TextEditingController();
  final complaintTypeController = TextEditingController();
  final subjectController = TextEditingController();
  final noteController = TextEditingController();
  final categoryObs = "".obs;

  final Map<String, String>? param = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    if (param != null) {
      complaintTypeController.text = param!["type"].toString();
      transactionNumberController.text = param!["transactionNumber"].toString();
    }
  }

  final complainCategoryList = [
    "Money Transfer",
    "Utility",
    "AEPS, MATM, MPOS",
    "Credit Card",
    "Aadhaar Pay",
    "Money Requests",
    "Statement",
    "Charge & Commission",
    "Other"
  ];

  postNewComplain() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    final note = noteController.text;
    final transactionNumber = transactionNumberController.text;
    final subject = subjectController.text;

    StatusDialog.progress();

    final response = await repo.postComplain({
      "cat_type":
          (param != null) ? complaintTypeController.text : categoryObs.value,
      "transaction_no": transactionNumber,
      "subject_name": subject,
      "full_desc": note,
    });
    Get.back();
    if (response.code == 1) {
      StatusDialog.success(title: response.message)
          .then((value) => Get.back(result: true));
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  @override
  void dispose() {
    transactionNumberController.dispose();
    subjectController.dispose();
    noteController.dispose();
    super.dispose();
  }
}
