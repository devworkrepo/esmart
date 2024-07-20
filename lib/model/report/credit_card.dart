import 'package:get/get.dart';

class CreditCardReportResponse {
  late int code;
  late String status;
  late String message;
  List<CreditCardReport>? reports;

  CreditCardReportResponse();

  CreditCardReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    if (json["translist"] != null) {
      reports = List.from(json['translist'])
          .map((e) => CreditCardReport.fromJson(e))
          .toList();
    }
  }
}

class CreditCardReport {
  String? mobileNumber;
  String? cardHolderName;
  String? cardNumber;
  String? cardType;
  String? transactionNumber;
  String? bankName;
  String? ifscCode;
  String? amount;
  String? charge;
  String? commission;
  String? utrNumber;
  String? transactionStatus;
  String? transactionMessage;
  String? date;

  RxBool isExpanded = false.obs;

  CreditCardReport.fromJson(Map<String, dynamic> json) {
    transactionNumber = json['transaction_no'];
    bankName = json['bank'];
    ifscCode = json['ifsc'];
    amount = json['amount'].toString();
    charge = json['charge'].toString();
    commission = json['commision'].toString();
    utrNumber = json['utr_no'];
    transactionStatus = json['trans_status'];
    transactionMessage = json['trans_message'];
    date = json['addeddate'];
    mobileNumber = json["mobile_no"];
    cardHolderName = json["card_holdername"];
    cardNumber = json["card_no"];
    cardType = json["card_type"];
  }
}
