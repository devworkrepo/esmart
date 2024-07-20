class MoneyRequestUpdateResponse{

  late int code;
  late String message;
  late String status;
  String? requestId;
  String? amount;
  String? type;
  String? depositDate;
  String? referenceNumber;
  String? remark;
  String? bankAccountNumber;
  String? picName;


  MoneyRequestUpdateResponse();

  MoneyRequestUpdateResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    requestId = json["requestid"];
    amount = json["amount"];
    type = json["type"];
    depositDate = json["deposit_date"];
    referenceNumber = json["ref_no"];
    remark = json["remark"];
    bankAccountNumber = json["bank_acc_name"];
    picName = json["picname"];

  }
}