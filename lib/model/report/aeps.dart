import 'package:get/get.dart';

class AepsReportResponse {
  late int code;
  String? status;
  String? message;
  String? total_aeps;
  String? total_matm;
  String? totalamt;
  String? total_mpos;
  String? total_pending;
  String? totalcomm;
  String? totalcount;
  List<AepsReport>? reportList;

  AepsReportResponse();

  AepsReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];

    totalamt = json["totalamt"].toString();
    total_aeps = json["total_aeps"].toString();
    total_matm = json["total_matm"].toString();
    total_mpos = json["total_mpos"].toString();
    total_pending = json["total_pending"].toString();
    totalcomm = json["totalcomm"].toString();
    totalcount = json["totalcount"].toString();

    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => AepsReport.fromJson(e))
          .toList();
    }
  }
}

class AepsReport {
  String? transactionNumber;
  String? bcid;
  String? mobileNumber;
  String? aadhaarNumber;
  String? transactionType;
  String? amount;
  String? commission;
  String? bankName;
  String? transactionId;
  String? transactionStatus;
  String? transactionMessage;
  String? rrn;
  String? transctionDate;
  RxBool isExpanded = false.obs;

  AepsReport.fromJson(Map<String, dynamic> json) {
    transactionNumber = json["transaction_no"];
    bcid = json["bcid"];
    mobileNumber = json["mobileno"];
    aadhaarNumber = json["aadharno"];
    transactionType = json["txntype"];
    amount = json["amount"].toString();
    commission = json["commission"].toString();
    bankName = json["bank_name"];
    transactionId = json["transactionid"];
    transactionStatus = json["trans_status"];
    transactionMessage = json["trans_message"];
    rrn = json["rrn"];
    transctionDate = json["addeddate"];
  }
}
