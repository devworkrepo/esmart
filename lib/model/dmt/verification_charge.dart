class DmtVerificationChargeResponse {

  late final int status;
  late final String message;
  Data? data;

  DmtVerificationChargeResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }
}

class Data {

  String? chargeAmount;

  Data.fromJson(Map<String, dynamic> json){
    chargeAmount = json['charge_amount'].toString();
  }

}