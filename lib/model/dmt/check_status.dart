class DmtCheckStatus{
  String? accountNumber;
  String? bankName;
  String? beneficiaryName;
  String? senderNumber;
  String? ifsc;
  String? amount;
  String? transactionId;
  String? bankRef;
  String? statusDescription;
  String? orderId;
  String? slipId;
  String? mode;
  String? transactionTime;


  DmtCheckStatus.fromJson(Map<String,dynamic> json){
    accountNumber = json["account_number"];
    bankName = json["bank_name"];
    beneficiaryName = json["bene_name"];
    senderNumber = json["sender_number"];
    ifsc = json["ifsc"];
    amount = json["amount"].toString();
    transactionId = json["txn_id"];
    bankRef = json["bank_ref"];
    statusDescription = json["status_description"];
    orderId = json["order_id"].toString();
    slipId = json["slip_id"];
    mode = json["mode"];
    transactionTime = json["transaction_time"];
  }
}