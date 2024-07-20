class SignUpResponse {
  late int code;
  late String status;
  late String message;
  String? regid;



  SignUpResponse();

  SignUpResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    regid = json["regid"];

  }

}
