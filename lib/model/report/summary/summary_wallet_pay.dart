import 'package:get/get.dart';

class SummaryWalletPayReport {
  late int code;
  String? status;
  String? message;
  String? total_count;
  String? total_amt;
  String? charge_paid;
  String? amt_rec;
  String? amt_trf;

  SummaryWalletPayReport();

  SummaryWalletPayReport.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    total_count = json["total_count"];
    total_amt = json["total_amt"];
    charge_paid = json["charge_paid"];
    amt_rec = json["amt_rec"];
    amt_trf = json["amt_trf"];
  }
}
