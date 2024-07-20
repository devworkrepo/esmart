class PaytmLoadTransactionResponse{
  late int code;
  String? status;
  String? message;
  String? transactionNumber;
  String? mobileNumber;
  String? operatorName;
  String? amount;
  String? rechargeType;
  String? operatorRefNumber;
  String? transactionStatus;
  String? transactionResponse;

  PaytmLoadTransactionResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transactionNumber = json["transaction_no"];
    mobileNumber = json["mobile_no"];
    operatorName = json["operator_name"];
    amount = json["amount"];
    rechargeType = json["rech_type"];
    operatorRefNumber = json["operator_refno"];
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
  }

}