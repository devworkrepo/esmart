class TransactionInfoResponse {
  late int code;
  String? status;
  String? message;
  String? trans_status;
  String? trans_response;

  TransactionInfoResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    trans_status = json["trans_status"];
    trans_response = json["trans_response"];
  }
}
