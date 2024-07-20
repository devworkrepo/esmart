import 'package:get/get.dart';

class CreditRefundListResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<CreditCardRefund>? reports;

  CreditRefundListResponse();

  CreditRefundListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    if (json["translist"] != null) {
      reports = List.from(json["translist"])
          .map((e) => CreditCardRefund.fromJson(e))
          .toList();
    }
  }
}

class CreditCardRefund {
  String? cardHolderName;
  String? cardNumber;
  String? cardType;
  String? mobileNumber;
  String? ifsc;
  String? bank;
  String? charge;
  String? commission;
  String? utrNumber;
  String? transactionMessage;
  String? transactionNumber;
  String? amount;
  String? transactionStatus;
  String? transactionResponse;
  String? date;
  var isExpanded = RxBool(false);

  CreditCardRefund.fromJson(Map<String, dynamic> json) {
    transactionNumber = json["transaction_no"];
    amount = json["amount"].toString();
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
    date = json["addeddate"];
    mobileNumber = json["mobile_no"];
    cardHolderName = json["card_holdername"];
    cardNumber = json["card_no"];
    cardType = json["card_type"];
    ifsc = json["ifsc"];
    bank = json["bank"];
    charge = json["charge"].toString();
    commission = json["commision"].toString();
    utrNumber = json["utr_no"];
    transactionMessage = json["trans_message"];
  }
}
