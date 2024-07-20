class ComplaintListResponse {
  late int code;
  String? status;
  String? message;
  String? rowid;
  List<Complaint>? translist;

  ComplaintListResponse();

  ComplaintListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    rowid = json["rowid"];
    if (json["translist"] != null) {
      translist = List.from(json['translist'])
          .map((e) => Complaint.fromJson(e))
          .toList();
    }
  }
}

class Complaint {
  String? complaintid;
  String? ticket_no;
  String? cat_type;
  String? transaction_no;
  String? subject_name;
  String? full_desc;
  String? status;
  String? addeddate;
  String? updateddate;
  String? closedate;
  bool? isread;

  Complaint.fromJson(Map<String, dynamic> json) {
    complaintid = json["complaintid"];
    ticket_no = json["ticket_no"];
    cat_type = json["cat_type"];
    transaction_no = json["transaction_no"];
    subject_name = json["subject_name"];
    full_desc = json["full_desc"];
    status = json["status"];
    addeddate = json["addeddate"];
    updateddate = json["updateddate"];
    closedate = json["closedate"];
    isread = json["isread"];
  }
}



class ComplaintCommentResponse {
  late int code;
  late String message;
  late List<ComplaintComment> list;

  ComplaintCommentResponse.fromJson(Map<String, dynamic> json){
    code = json["code"];
    message = json["message"];
    list = List.from(json["data"])
        .map((e) => ComplaintComment.fromJson(e))
        .toList();
  }
}

class ComplaintComment {

  String? addeddate;
  String? replydesc;
  String? retailerid;
  String? userid;

  ComplaintComment({
    required this.addeddate,
    required this.replydesc,
    required this.retailerid,
    required this.userid
});

  ComplaintComment.fromJson(Map<String, dynamic> json){
    addeddate = json["addeddate"];
    replydesc = json["replydesc"];
    retailerid = json["retailerid"];
    userid = json["userid"];
  }
}
