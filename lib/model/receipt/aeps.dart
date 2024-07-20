class AepsReceiptResponse{
  late int code;
  String? status;
  String? message;
  String? outName;
  String? outletMobile;
  String? mobileNumber;
  String? aadhaarNumber;
  String? bankName;
  String? transactionNumber;
  String? transactionType;
  String? utrNumber;
  String? transactionResponse;
  String? transactionStatus;
  String? amount;
  String? date;
  String? amountInWord;

  AepsReceiptResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    outName = json["outlet_name"];
    outletMobile = json["outlet_mobile"];
    mobileNumber = json["customer_mobile"];
    aadhaarNumber = json["customer_aadhar"];
    bankName = json["bank_name"];
    transactionNumber = json["trans_no"];
    transactionType = json["trans_type"];
    utrNumber = json["utr_no"];
    transactionResponse = json["trans_response"];
    transactionStatus = json["trans_status"];
    amount = json["amount"].toString();
    date = json["addeddate"].toString();
    amountInWord = json["amountwords"];
  }
}