import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/complaint.dart';

abstract class ComplainRepo {

  Future<CommonResponse> postComplain(Map<String,String> data);
  Future<ComplaintListResponse> getComplains(Map<String,String> data);
  Future<CommonResponse> addReply(Map<String,String> data);
  Future<ComplaintCommentResponse> fetchReplies(Map<String,String> data);

}