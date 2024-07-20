
class MatmResult{
  late bool status;
  int? statusId;
  late double transAmount;
  late double balAmount;
  late String bankRrn;
  late String time;
  late String message;
  late String cardNumber;
  late String bankName;

  MatmResult.fromJson(Map<dynamic,dynamic> json){
    status=json["status"];
    transAmount=json["transAmount"];
    balAmount=json["balAmount"];
    bankRrn=json["bankRrn"];
    time=json["time"];
    message=json["message"];
    cardNumber=json["cardNumber"];
    bankName=json["bankName"];
  }

}






class MatmRequestResponse{
  late int code;
  String? message;
  String? status;
  String? txnId;
  String? superMerchantPassword;
  String? superMerchantId;
  String? clientId;
  String? loginId;
  String? loginPin;

  MatmRequestResponse.fromJson(Map<String,dynamic> json){
    code=json["code"];
    message=json["message"];
    status=json["status"];
    txnId=json["txnId"];
    superMerchantPassword=json["superMerchantPassword"];
    superMerchantId=json["superMerchantId"];
    clientId=json["clientId"];
    loginId=json["loginId"];
    loginPin=json["loginPin"];
  }

}


class MatmCheckTransactionInitiated{
  late int status;
  late String message;
  bool?  isInitiated;

  MatmCheckTransactionInitiated.fromJson(Map<String,dynamic> json){

    message=json["message"];
    status=json["status"];
    isInitiated=json["is_initiated"];
  }

}
