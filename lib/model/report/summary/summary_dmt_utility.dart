import 'package:get/get.dart';

class SummaryDmtUtilityReport {


  late int code;
  String? status;
  String? message;
  String? total_count;
  String? total_amt;
  String? charges_paid;
  String? comm_rec;
  String? refund_pending;
  String? refunded;

  SummaryDmtUtilityReport();

  SummaryDmtUtilityReport.fromJson(Map<String, dynamic> json) {

    code=json["code"];
    status=json["status"];
    message=json["message"];
    total_count=json["total_count"];
    total_amt=json["total_amt"];
    charges_paid=json["charges_paid"];
    comm_rec=json["comm_rec"];
    refund_pending=json["refund_pending"];
    refunded=json["refunded"];
  }
}
