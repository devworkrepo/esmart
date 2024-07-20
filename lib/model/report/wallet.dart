import 'package:get/get.dart';

class WalletPayReportResponse{
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<WalletPayReport>? reports;

  WalletPayReportResponse();

  WalletPayReportResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    if(json["translist"] != null){
      reports = List.from(json["translist"]).map((e) => WalletPayReport.fromJson(e)).toList();
    }
  }
}

class WalletPayReport{
  String? date;
  String? refNumber;
  String? paidBy;
  String? receivedBy;
  String? remark;
  String? amount;
  String? payStatus;
  String? payMessage;
  RxBool isExpanded = false.obs;

  WalletPayReport.fromJson(Map<String,dynamic> json){
    date = json["date"];
    refNumber = json["ref_no"];
    paidBy = json["paid_by"];
    receivedBy = json["received_by"];
    remark = json["remark"];
    amount = json["amount"].toString();
    payStatus = json["pay_status"];
    payMessage = json["pay_message"];
  }
}