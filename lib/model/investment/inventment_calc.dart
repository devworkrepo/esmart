
class InvestmentCalcResponse {
  late int code;
  late String status;
  late String message;
  String? intrate;
  String? matureamt;
  String? intamt;
  String? maturedate;

  InvestmentCalcResponse();

  InvestmentCalcResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json["code"];
    message = json['message'];
    intrate = json["intrate"].toString();
    matureamt = json["matureamt"].toString();
    intamt = json["intamt"].toString();
    maturedate = json["maturedate"];

  }
}
