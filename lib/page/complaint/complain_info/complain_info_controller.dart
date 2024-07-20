import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo_impl/complain_repo_impl.dart';
import 'package:esmartbazaar/model/complaint.dart';
import 'package:esmartbazaar/util/date_util.dart';

import '../../../data/repo/complain_repo.dart';

class ComplainInfoController extends GetxController {
  final Complaint complain = Get.arguments;
  final appPreference = Get.find<AppPreference>();
  final textController = TextEditingController();
  final ComplainRepo repo = Get.find<ComplainRepoImpl>();

  final isKeyboardOpen = false.obs;

  final commentListController = ScrollController();

  final RxList<ComplaintComment> commentsObs = <ComplaintComment>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchReplies();
  }

  addReply() async {
    final text = textController.text;
    final complainId = complain.complaintid.toString();
    textController.text = "";

    final comment = ComplaintComment(
        addeddate: DateUtil.currentDateWithddMMyyyyHHss(),
        replydesc: text,
        retailerid: appPreference.user.agentId.toString(),
        userid: "0");
    commentsObs.insert(0, comment);
    await repo.addReply({
      "complaintid": complainId,
      "replydesc": text,
    });
  }

  fetchReplies() async {
    final response = await repo
        .fetchReplies({"complaintid": complain.complaintid.toString()});

    commentsObs.value = response.list;
  }
}
