
class InvestmentBalanceResponse {
  late int code;
  late String status;
  late String message;
  String? balance;
  String? pan_no;
  String? trans_no;
  String? words;

  InvestmentBalanceResponse();

  InvestmentBalanceResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json["code"];
    message = json['message'];
    balance = json["balance"].toString();
    pan_no = json["pan_no"];
    trans_no = json["trans_no"];
    words = json["words"];

  }
}
