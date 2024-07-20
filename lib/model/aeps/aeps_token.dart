class AepsTokenCheckResponse {
  late int code;
  late String message;
  String? status;
  String? token;

  AepsTokenCheckResponse();
  AepsTokenCheckResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    token = json["token"];

  }

}
