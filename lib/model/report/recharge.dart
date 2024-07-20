import 'package:get/get.dart';

class RechargeReportResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<RechargeReport>? reports;

  RechargeReportResponse();

  RechargeReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    totalCount = json['totalcount'].toString();
    totalAmount = json['totalamt'].toString();
    if (json["rechlist"] != null) {
      reports = List.from(json['rechlist'])
          .map((e) => RechargeReport.fromJson(e))
          .toList();
    }
  }
}

class RechargeReport {
  String? transactionNumber;
  String? mobileNumber;
  String? refMobileNumber;
  String? rechargeType;
  String? operatorName;
  String? payId;
  String? operatorRefNumber;
  String? amount;
  String? transactionStatus;
  String? transactionResponse;
  String? transactionDate;
  RxBool isExpanded = false.obs;

  RechargeReport.fromJson(Map<String, dynamic> json) {
    transactionNumber = json["transaction_no"];
    mobileNumber = json["mobile_no"];
    refMobileNumber = json["ref_mobile_no"];
    rechargeType = json["rech_type"];
    operatorName = json["operator_name"];
    payId = json["payid"];
    operatorRefNumber = json["operator_refno"];
    amount = json["amount"];
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
    transactionDate = json["addeddate"];
  }
}
