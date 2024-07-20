import 'package:get/get.dart';

class VirtualTransactionReportResponse {
  late int code;
  late String message;
  String? status;
  List<VirtualTransactionReport>? reports;

  VirtualTransactionReportResponse();

  VirtualTransactionReportResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
    reports = (json["translist"] != null)
        ? List.from(json["translist"])
            .map((e) => VirtualTransactionReport.fromJson(e))
            .toList()
        : null;
  }
}

class VirtualTransactionReport {
  String? collid;
  String? requestNumber;
  String? date;
  String? mode;
  String? van;
  String? utrNumber;
  String? transactionAmount;
  String? remitterName;
  String? remitterAccountNumber;
  String? remitterIfscCode;
  String? senderToReceiverInformation;
  String? addedDate;
  String? status;
  String? modifyDate;
  String? modifyRemark;
  var isExpanded = false.obs;

  VirtualTransactionReport.fromJson(Map<String, dynamic> json) {
    collid = json["collid"];
    requestNumber = json["requestno"];
    date = json["Date"];
    mode = json["Mode"];
    van = json["VAN"];
    utrNumber = json["UTR_number"];
    transactionAmount = json["Transaction_Amount"];
    remitterName = json["Remitter_Name"];
    remitterAccountNumber = json["Remitter_Account_Number"];
    remitterIfscCode = json["SenderIFSC_Code"];
    senderToReceiverInformation = json["Sender_to_receiver_information"];
    addedDate = json["addeddate"];
    status = json["status"];
    modifyDate = json["modifydate"];
    modifyRemark = json["modifyremark"];
  }
}
