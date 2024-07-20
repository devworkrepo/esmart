import 'package:get/get.dart';

class InvestmentWithdrawnListResponse {
  late int code;
  late String status;
  late String message;
  List<InvestmentWithdrawnListItem>? reports;

  InvestmentWithdrawnListResponse();

  InvestmentWithdrawnListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    if (json["translist"] != null) {
      reports = List.from(json['translist'])
          .map((e) => InvestmentWithdrawnListItem.fromJson(e))
          .toList();
    }
  }
}

class InvestmentWithdrawnListItem {
  String? trfid;
  String? fd_refno;
  String? trans_no;
  String? acc_name;
  String? acc_no;
  String? ifsc;
  String? amount;
  String? charge;
  String? utr_no;
  String? remark;
  String? addeddate;
  String? trans_status;
  String? trans_response;
  RxBool isExpanded = false.obs;

  InvestmentWithdrawnListItem.fromJson(Map<String, dynamic> json) {
    trfid = json["trfid"];
    fd_refno = json["fd_refno"];
    trans_no = json["trans_no"];
    acc_name = json["acc_name"];
    acc_no = json["acc_no"];
    ifsc = json["ifsc"];
    amount = json["amount"];
    charge = json["charge"];
    utr_no = json["utr_no"];
    remark = json["remark"];
    addeddate = json["addeddate"];
    trans_status = json["trans_status"];
    trans_response = json["trans_response"];
  }
}
