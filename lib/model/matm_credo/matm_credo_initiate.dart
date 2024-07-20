class MatmCredoInitiate {
  late int code;
  late String message;
  String? status;
  String? transaction_no;
  String? loginId;
  String? loginPass;
  String? terminalid;

  MatmCredoInitiate();

  MatmCredoInitiate.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transaction_no = json["transaction_no"];
    loginId = json["loginId"];
    loginPass = json["loginPass"];
    terminalid = json["terminalid"];
  }
}
