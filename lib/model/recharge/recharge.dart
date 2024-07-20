class RechargeResponse {
  late int code;
  late String status;
  late String message;
  String ? transactionNumber;
  String ? mobileNumber;
  String ? customerId;
  String ? operatorName;
  String ? amount;
  String ? rechargeType;
  String ? operatorRefNumber;
  String ? transactionStatus;
  String ? transactionResponse;


  RechargeResponse._();

  RechargeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    transactionNumber = json['transaction_no'];
    mobileNumber = json['mobile_no'];
    customerId = json['customer_id'];
    operatorName = json['operator_name'];
    amount = json['amount'];
    rechargeType = json['rech_type'];
    operatorRefNumber = json['operator_refno'];
    transactionStatus = json['trans_status'];
    transactionResponse = json['trans_response'];

  }

}