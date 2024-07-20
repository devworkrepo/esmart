class SenderKycCaptcha{
  late int code;
  String? status;
  String? message;
  String? uuid;
  String? captcha_img;

  SenderKycCaptcha();
  SenderKycCaptcha.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    uuid = json["uuid"];
    captcha_img = json["captcha_img"];
  }
}