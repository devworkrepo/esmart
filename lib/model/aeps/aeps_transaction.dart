class AepsTransactionResponse {
  AepsTransactionResponse();

  late int  code;
  String? status;
  String? message;
  String? transactionStatus;
  String? transactionResponse;
  String? rrnNumber;
  String? availableBalance;
  String? amount;
  String? aadharno;
  String? mobileno;



  AepsTransactionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    transactionStatus = json['trans_status'];
    transactionResponse = json['trans_response'];
    rrnNumber = json['bank_rrn'];
    availableBalance = json['avail_bal'];
    amount = json['amount'];
    aadharno = json['aadharno'];
    mobileno = json['mobileno'];


  }
}
