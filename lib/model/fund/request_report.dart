import 'package:get/get.dart';

class FundRequestReportResponse {
  late int code;
  late String status;
  late String message;
  String? totalAmount;
  List<FundRequestReport>? moneyList;

  FundRequestReportResponse();

  FundRequestReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    totalAmount = json['totalamount'].toString();
    moneyList = List.from(json['moneylist'])
        .map((e) => FundRequestReport.fromJson(e))
        .toList();
  }
}

class FundRequestReport {
  String? requestId;
  String? requestNumber;
  String? amount;
  String? type;
  String? depositeDate;
  String? referenceNumber;
  String? remark;
  String? bankAccountName;
  String? picName;
  String? status;
  String? addedDate;
  String? modifiedDate;
  String? modifiedRemark;
  RxBool isExpanded = false.obs;

  FundRequestReport.fromJson(Map<String, dynamic> json) {
    requestId = json['requestid'];
    requestNumber = json['requestno'];
    amount = json['amount'];
    type = json['type'];
    depositeDate = json['deposit_date'];
    referenceNumber = json["ref_no"];
    remark = remark = json["remark"];
    bankAccountName = json['bank_acc_name'];
    picName = json['picname'];
    status = json['status'];
    addedDate = json["addeddate"];
    modifiedDate = json['modifydate'];
    modifiedRemark = json['modifyremark'];
  }
}
