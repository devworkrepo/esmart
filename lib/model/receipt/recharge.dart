class RechargeReceiptResponse{
  late int code;
  String? status;
  String? message;
  String? outletName;
  String? outletMobile;
  String? customerId;
  String? refMobileNumber;
  String? operatorName;
  String? circleName;
  String? rechargeType;
  String? transactionNumber;
  String? operatorRefNumber;
  String? transactionStatus;
  String? amount;
  String? date;
  String? amountInWords;
  RechargeReceiptResponse.fromJson(Map<String,dynamic> json){

    code = json["code"];
    status = json["status"];
    message = json["message"];
    outletName = json["outlet_name"];
    outletMobile = json["outlet_mobile"];
    customerId = json["customer_id"];
    refMobileNumber = json["ref_mobileno"];
    operatorName = json["operator_name"];
    circleName = json["circle_name"];
    rechargeType = json["rech_type"];
    transactionNumber = json["tran_no"];
    operatorRefNumber = json["operator_ref_no"];
    transactionStatus = json["trans_status"];
    amount = json["amount"].toString();
    date = json["addeddate"];
    amountInWords = json["amountwords"];

  }

}