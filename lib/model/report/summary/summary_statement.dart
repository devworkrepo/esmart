import 'package:get/get.dart';

class SummaryStatementReport {
  late int code;

  String? status;

  String? message;

  String? avail_balance;

  String? balance_words;

  String? total_credit;

  String? total_debit;

  String? amt_cr;

  String? amt_dr;

  String? chg_cr;

  String? chg_dr;

  String? comm_cr;

  String? comm_dr;

  String? tds_cr;

  String? tds_dr;



  SummaryStatementReport();

  SummaryStatementReport.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    avail_balance = json["avail_balance"];
    balance_words = json["balance_words"];
    total_credit = json["total_credit"];
    total_debit = json["total_debit"];
    amt_cr = json["amt_cr"];
    amt_dr = json["amt_dr"];
    chg_cr = json["chg_cr"];
    chg_dr = json["chg_dr"];
    comm_cr = json["comm_cr"];
    comm_dr = json["comm_dr"];
    tds_cr = json["tds_cr"];
    tds_dr = json["tds_dr"];
  }
}
