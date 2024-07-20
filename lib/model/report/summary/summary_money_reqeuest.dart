import 'package:get/get.dart';

class SummaryMoneyRequestReport {


  late int code;
  String ? status;
  String ? message;
  String ? total_count;
  String ? total_amt;
  String ? cash_tot;
  String ? imps_tot;
  String ? cdm_tot;
  String ? online_tot;

  SummaryMoneyRequestReport();

  SummaryMoneyRequestReport.fromJson(Map<String, dynamic> json) {

    code = json["code"];
    status = json["status"];
    message = json["message"];
    total_count = json["total_count"];
    total_amt = json["total_amt"];
    cash_tot = json["cash_tot"];
    imps_tot = json["imps_tot"];
    cdm_tot = json["cdm_tot"];
    online_tot = json["online_tot"];
  }
}
