class AepsBalance{
  late int code;
  String? status;
  String? message;
  String? transaction_no;
  String? balance;


  AepsBalance();
  AepsBalance.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transaction_no = json["transaction_no"];
    balance = json["balance"].toString();
  }

}