class InvestmentCloseCalcResponse {
  late int code;
  late String status;
  late String message;
  String? balance;
  String? charges;
  String? closetype;
  String? trans_no;

  InvestmentCloseCalcResponse();

  InvestmentCloseCalcResponse.fromJson(Map<String, dynamic> json) {

    code = json["code"];
    status = json["status"];
    message = json["message"];
    balance = json["balance"].toString();
    charges = json["charges"].toString();
    closetype = json["closetype"];
    trans_no = json["trans_no"];

  }
}