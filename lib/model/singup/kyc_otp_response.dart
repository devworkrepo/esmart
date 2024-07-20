class SignUpEKycResponse{
  late int code;
  late String message;
  late String status;
  String? uuid;
  String? captcha_txt;

  SignUpEKycResponse();
  SignUpEKycResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    uuid = json['uuid'];
    captcha_txt = json['captcha_txt'];
  }
}