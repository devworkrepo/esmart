class CalculateChargeResponse {
  late int code;
  late String message;
  late String status;
  String? calcId;
  String? isOtp;
  String? charge;
  String? amount;
  String? transno;
  List<CalculateCharge>? chargeList;

  CalculateChargeResponse();

  CalculateChargeResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    calcId = json["calcid"];
    isOtp = json["isotp"];
    charge = json["charge"];
    amount= json["amount"];
    transno= json["transno"];

    if (json["calclists"] != null) {
      chargeList = List<CalculateCharge>.from(
          json["calclists"].map((e) => CalculateCharge.fromJson(e)));
    }
  }

}

class CalculateCharge {
  String? charge;
  String? amount;
  String? srno;

  CalculateCharge.fromJson(Map<String, dynamic> json) {
    charge = json["charge"].toString();
    amount = json["amount"].toString();
    srno = json["srno"].toString();
  }

}
