import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/complain_repo.dart';
import 'package:esmartbazaar/data/repo_impl/complain_repo_impl.dart';
import 'package:esmartbazaar/model/complaint.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';

class ComplaintListController extends GetxController {
  final ComplainRepo repo = Get.find<ComplainRepoImpl>();

  var complainResponseObs = Resource.onInit(data: ComplaintListResponse()).obs;
  var tickNumberController = TextEditingController();

  var category = "All Services".obs;
  var inbox = "Complaint Inbox".obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      fetchComplaints();
    });
  }

  fetchComplaints({Map<String, String>? param}) async {
    final mInbox = (inbox.value == "Open Complaints")
        ? "Open"
        : (inbox.value == "Close Complaints")
            ? "Closed"
            : "";

    final mCategory = (category.value == "All Services") ? "" : category.value;

    var mParam = {"cat_type": mCategory, "status": mInbox};
    try {
      complainResponseObs.value = const Resource.onInit();
      final response =
          await repo.getComplains((param != null) ? param : mParam);
      complainResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      complainResponseObs.value = Resource.onFailure(e);
    }
  }

  void searchTicketNumber() async {
    var params = {
      "ticket_no": tickNumberController.text,
    };
    fetchComplaints(param: params);
  }

  void refreshList() async {
    category.value = "All Services";
    inbox.value = "Complaint Inbox";
    tickNumberController.text = "";
    fetchComplaints(param: {});
  }


}
