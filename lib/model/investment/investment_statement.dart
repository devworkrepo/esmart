import 'package:get/get.dart';

class InvestmentStatementResponse {


  late int code;
  String? status;
  String? message;
  String? totalcr;
  String? totaldr;
  String? balance;
  String? words;
  String? fdrefno;
  String? openamt;
  String? matureamt;
  String? roi;
  String? opendate;
  String? completedate;
  String? tenure;
  List<InvestmentStatement>? reportList;

  InvestmentStatementResponse();

  InvestmentStatementResponse.fromJson(Map<String, dynamic> json) {

    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalcr = json["totalcr"].toString();
    totaldr = json["totaldr"].toString();
    balance = json["balance"].toString();
    words = json["words"].toString();
    fdrefno = json["fdrefno"].toString();
    openamt = json["openamt"].toString();
    matureamt = json["matureamt"].toString();
    roi = json["roi"].toString();
    opendate = json["opendate"].toString();
    completedate = json["completedate"].toString();
    tenure = json["tenure"].toString();
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => InvestmentStatement.fromJson(e))
          .toList();
    }
  }
}

class InvestmentStatement {

  String? date;
  String? narration;
  String? remark;
  String? in_amt;
  String? out_amt;
  String? in_charge;
  String? out_charge;
  String? in_comm;
  String? out_comm;
  String? in_tds;
  String? out_tds;
  String? balance;
  RxBool isExpanded = false.obs;


  InvestmentStatement.fromJson(Map<String, dynamic> json) {

    date = json["date"].toString();
    narration = json["narration"].toString();
    remark = json["remark"].toString();
    in_amt = json["in_amt"].toString();
    out_amt = json["out_amt"].toString();
    in_charge = json["in_charge"].toString();
    out_charge = json["out_charge"].toString();
    in_comm = json["in_comm"].toString();
    out_comm = json["out_comm"].toString();
    in_tds = json["in_tds"].toString();
    out_tds = json["out_tds"].toString();
    balance = json["balance"].toString();
  }
}
