
class BillExtraParamResponse {
  late int code;
  late String status;
  late String message;
  String? field1;
  String? field2;
  String? field3;
  String? transactionNumber;

  BillExtraParamResponse();

  BillExtraParamResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    field1 = json["field1"];
    field2 = json["field2"];
    field3 = json["field3"];
    transactionNumber = json["transaction_no"];
  }
}