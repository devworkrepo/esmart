class SignUpCaptchaResponse{
  late int code;
  late String message;
  late String status;
  String? uuid;
  String? captcha_img;

  SignUpCaptchaResponse();
  SignUpCaptchaResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    uuid = json['uuid'];
    captcha_img = json['captcha_img'];
  }
}