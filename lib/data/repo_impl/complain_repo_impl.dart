import 'package:get/get.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/complaint.dart';
import 'package:esmartbazaar/service/network_client.dart';

import '../repo/complain_repo.dart';

class ComplainRepoImpl extends ComplainRepo {
  NetworkClient client = Get.find();

  @override
  Future<CommonResponse> postComplain(Map<String,String> data) async {
    var response = await client.post("/AddNewComplaint",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ComplaintListResponse> getComplains(Map<String, String> data) async {
    var response = await client.post("/GetComplaintList",data: data);
    return ComplaintListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addReply(Map<String, String> data) async {
    var response = await client.post("/AddReply",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ComplaintCommentResponse> fetchReplies(Map<String, String> data) async {
    var response = await client.post("/GetRepliesList",data: data);
    return ComplaintCommentResponse.fromJson(response.data);
  }

}
