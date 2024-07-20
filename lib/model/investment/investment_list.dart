import 'package:get/get.dart';

class InvestmentListResponse {
  late int code;
  late String status;
  late String message;
  int? totalcount;
  int? totalamt;
  String? total_int;
  String? total_withamt;
  String? total_matuamt;
  List<InvestmentListItem>? reports;

  InvestmentListResponse();

  InvestmentListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalcount = json["totalcount"];
    totalamt = json["totalamt"];
    total_int = json["total_int"];
    total_withamt = json["total_withamt"];
    total_matuamt = json["total_matuamt"];
    if (json["translist"] != null) {
      reports = List.from(json['translist'])
          .map((e) => InvestmentListItem.fromJson(e))
          .toList();
    }
  }
}

class InvestmentListItem {
  String? fdid;
  String? fd_refno;
  String? pan_no;
  String? amount;
  String? tenure_value;
  String? tenure_type;
  String? int_rate;
  String? int_earned;
  String? current_amount;
  String? mature_amount;
  String? addeddate;
  String? completedate;
  String? closeddate;
  String? closedtype;
  String? trans_status;
  String? trans_response;
  String? pay_status;
  bool? isclosebtn;
  RxBool isExpanded = false.obs;

  InvestmentListItem.fromJson(Map<String, dynamic> json) {
    fdid = json["fdid"];
    fd_refno = json["fd_refno"];
    pan_no = json["pan_no"];
    amount = json["amount"];
    tenure_value = json["tenure_value"];
    tenure_type = json["tenure_type"];
    int_rate = json["int_rate"];
    int_earned = json["int_earned"];
    current_amount = json["current_amount"];
    mature_amount = json["mature_amount"];
    addeddate = json["addeddate"];
    completedate = json["completedate"];
    closeddate = json["closeddate"];
    closedtype = json["closedtype"];
    trans_status = json["trans_status"];
    trans_response = json["trans_response"];
    pay_status = json["pay_status"];
    isclosebtn = json["isclosebtn"];
  }
}
