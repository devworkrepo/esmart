import 'package:get/get.dart';

class SummaryAepsReport {



  late int code;
  String? status;
  String? message;
  String? total_count;
  String? total_amt;
  String? charges_paid;
  String? comm_rec;
  String? aeps_no;
  String? matm_no;
  String? mpos_no;


  SummaryAepsReport();

  SummaryAepsReport.fromJson(Map<String, dynamic> json) {

    code=json["code"];
    status=json["status"];
    message=json["message"];
    total_count=json["total_count"];
    total_amt=json["total_amt"];
    charges_paid=json["charges_paid"];
    comm_rec=json["comm_rec"];
    aeps_no=json["aeps_no"];
    matm_no=json["matm_no"];
    mpos_no=json["mpos_no"];
  }
}
