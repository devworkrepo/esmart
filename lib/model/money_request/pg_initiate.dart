class PgInitiateResponse {
  late int code;
  String? status;
  String? message;
  String? redirect_url;

  PgInitiateResponse();

  PgInitiateResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    redirect_url = json["redirect_url"];
  }
}
