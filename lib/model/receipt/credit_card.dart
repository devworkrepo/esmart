class CreditCardReceiptResponse{
  late int code;
  String? status;
  String? message;
  String? outletName;
  String? outletMobile;
  String? customerName;
  String? cardNumber;
  String? cardType;
  String? transactionNumber;
  String? utrNumber;
  String? transactionStatus;
  String? transactionResponse;
  String? amount;
  String? date;
  String? amountInWord;

  CreditCardReceiptResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    outletName = json["outlet_name"];
    outletMobile = json["outlet_mobile"];
    customerName = json["customer_name"];
    cardNumber = json["card_no"];
    cardType = json["card_type"];
    transactionNumber = json["trans_no"];
    utrNumber = json["utr_no"];
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
    amount = json["amount"].toString();
    date = json["addeddate"];
    amountInWord = json["amountwords"];
  }
}