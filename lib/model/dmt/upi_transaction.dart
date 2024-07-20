class UpiTransactionResponse {

  late int status;
  late String message;
  String? statusDescription;
  String ?txnId;
  String ?bankRef;
  String ?beneName;
  String ?senderNumber;
  String ?senderName;
  String ?mode;
  String ?transactionTime;
  String ?reportId;
  String ?slipId;

  UpiTransactionResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    statusDescription = json['status_description'];
    txnId = json['txn_id'];
    bankRef = json['bank_ref'];
    beneName = json['bene_name'];
    senderNumber = json['sender_number'];
    senderName = json['sender_name'];
    mode = json['mode'];
    transactionTime = json['transaction_time'];
    reportId = json['report_id'];
    slipId = json['slip_id'];
  }
}