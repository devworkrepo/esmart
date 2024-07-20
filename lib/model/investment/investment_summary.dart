class InvestmentSummaryResponse {
  late int code;
  String? aval_amt;
  String? completed_amt;
  String? int_earned;
  String? invest_active;
  String? invest_closed;
  String? invest_completed;
  String? invest_settled;
  String? message;
  String? pay_failed;
  String? pay_inprogress;
  String? pay_refunded;
  String? pay_success;
  String? status;
  String? tot_active;
  String? tot_amount;

  InvestmentSummaryResponse();

  InvestmentSummaryResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    aval_amt = json["aval_amt"];
    completed_amt = json["completed_amt"];
    int_earned = json["int_earned"];
    invest_active = json["invest_active"];
    invest_closed = json["invest_closed"];
    invest_completed = json["invest_completed"];
    invest_settled = json["invest_settled"];
    message = json["message"];
    pay_failed = json["pay_failed"];
    pay_inprogress = json["pay_inprogress"];
    pay_refunded = json["pay_refunded"];
    pay_success = json["pay_success"];
    status = json["status"];
    tot_active = json["tot_active"];
    tot_amount = json["tot_amount"];
  }
}
