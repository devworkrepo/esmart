import 'package:esmartbazaar/model/bank.dart';

class CreditCardType{
  String? name;
  CreditCardType();

  CreditCardType.fromJson(Map<String, dynamic> json) {
    name = json['typename'];
  }
}

class CreditCardTypeResponse{

  late int code;
  late String status;
  late String message;
  List<CreditCardType>? types;

  CreditCardTypeResponse();

  CreditCardTypeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    types = List.from(json["data"]).map((e) => CreditCardType.fromJson(e)).toList();
  }

}


class CreditCardLimitResponse{
  late int code;
  String? status;
  String? message;
  String? perTransaction;
  String? monthlyLimit;
  String? availLimit;

  CreditCardLimitResponse();


  CreditCardLimitResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    perTransaction = json['per_transaction'].toString();
    monthlyLimit = json['monthly_limit'].toString();
    availLimit = json['avail_limit'].toString();
  }

}


class CreditCardPaymentResponse{
  late int code;
  String ? status;
  String ? message;
  String ? outletName;
  String ? outletMobileNumber;
  String ? cardHolderName;
  String ? creditCardNumber;
  String ? creditCardType;
  String ? transactionDate;
  String ? transactionNumber;
  String ? amount;
  String ? utrNumber;
  String ? transactionStatus;
  String ? transactionResponse;
  String ? amountInWords;

  CreditCardPaymentResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    outletName = json["outlet_name"];
    outletMobileNumber = json["outlet_mobileno"];
    cardHolderName = json["card_holder"];
    creditCardNumber = json["credit_cardno"];
    creditCardType = json["card_type"];
    transactionDate = json["addeddate"];
    transactionNumber = json["trans_no"];
    amount = json["amount"].toString();
    utrNumber = json["utr_no"];
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
    amountInWords = json["amount_words"];
  }
}



