class AepsSettlementCalcResponse{


  late int code;
  String? status;
  String? message;
  String? transaction_no;
  String? charges;


  AepsSettlementCalcResponse();
  AepsSettlementCalcResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transaction_no = json["transaction_no"];
    charges = json["charges"].toString();
  }
}