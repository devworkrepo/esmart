class PgChargeResponse {
  late int code;
  String? message;
  String? status;
  String? charges;
  String? transaction_no;

  PgChargeResponse();

  PgChargeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    charges = json['charges'].toString();
    transaction_no = json['transaction_no'];
  }
}
