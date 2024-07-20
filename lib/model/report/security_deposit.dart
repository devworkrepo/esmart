import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SecurityDepositReportResponse {
  late int code;
  String? status;
  String? message;
  List<SecurityDepositReport>? translist;

  SecurityDepositReportResponse();

  SecurityDepositReportResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    translist = (json["translist"] != null)
        ? List.from(json["translist"])
            .map((e) => SecurityDepositReport.fromJson(e))
            .toList()
        : null;
  }
}

class SecurityDepositReport {
  String? transaction_no;
  String? first_name;
  String? last_name;
  String? mobile_no;
  String? email_id;
  String? dob;
  String? pan_no;
  String? aadhar_no;
  String? amount;
  String? status;
  String? remark;
  String? addeddate;
  RxBool isExpanded = false.obs;

  SecurityDepositReport();

  SecurityDepositReport.fromJson(Map<String, dynamic> json) {
    transaction_no = json["transaction_no"];
    first_name = json["first_name"];
    last_name = json["last_name"];
    mobile_no = json["mobile_no"];
    email_id = json["email_id"];
    dob = json["dob"];
    pan_no = json["pan_no"];
    aadhar_no = json["aadhar_no"];
    amount = json["amount"];
    status = json["status"];
    remark = json["remark"];
    addeddate = json["addeddate"];
  }
}
