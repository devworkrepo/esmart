import 'package:get/get.dart';

class AccountStatementResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  String? totalCharge;
  String? totalCommission;
  String? totalTds;
  List<AccountStatement>? reportList;

  AccountStatementResponse();

  AccountStatementResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    totalCharge = json["totalchg"].toString();
    totalCommission = json["totalcomm"].toString();
    totalTds = json["totaltds"].toString();
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => AccountStatement.fromJson(e))
          .toList();
    }
  }
}

class AccountStatement {
  String? date;
  String? narration;
  String? remark;
  String? inAmount;
  String? outAmount;
  String? inCharge;
  String? outCharge;
  String? inCommission;
  String? outCommission;
  String? inTds;
  String? outTds;
  String? balance;
  RxBool isExpanded = false.obs;


  AccountStatement.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    narration = json["narration"];
    remark = json["remark"];
    inAmount = json["in_amt"].toString();
    outAmount = json["out_amt"].toString();
    inCharge = json["in_charge"].toString();
    outCharge = json["out_charge"].toString();
    inCommission = json["in_comm"].toString();
    outCommission = json["out_comm"].toString();
    inTds = json["in_tds"].toString();
    outTds = json["out_tds"].toString();
    balance = json["balance"].toString();
  }
}
