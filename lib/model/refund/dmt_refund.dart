import 'package:get/get.dart';

class DmtRefundListResponse {
  late int code;
  String? message;
  String? status;
  String? totalAmount;
  List<DmtRefund>? list;

  DmtRefundListResponse();

  DmtRefundListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
    list = List.from(json["translist"]).map((e) {
      return DmtRefund.fromJson(e);
    }).toList();
  }
}

class DmtRefund {
  String? calcId;
  String? transactionNumber;
  String? senderNumber;
  String? beneficiaryName;
  String? accountNumber;
  String? isfscCode;
  String? amount;
  String? charge;
  String? commission;
  String? transactionType;
  String? utrNumber;
  String? transactionStatus;
  String? transactionMessage;
  String? transactionDate;
  var isExpanded = RxBool(false);

  DmtRefund.fromJson(Map<String, dynamic> json) {
    calcId = json["calcid"];
    transactionNumber = json["transaction_no"];
    senderNumber = json["remitter_mobile"];
    beneficiaryName = json["bene_name"];
    accountNumber = json["account_no"];
    isfscCode = json["ifsc"];
    amount = json["amount"].toString();
    charge = json["charge"].toString();
    commission = json["commision"].toString();
    transactionType = json["trans_type"];
    utrNumber = json["utr_no"];
    transactionStatus = json["trans_status"];
    transactionMessage = json["trans_message"];
    transactionDate = json["addeddate"];
  }
}
