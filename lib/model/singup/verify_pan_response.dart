class SignUpVerifyPanResponse{
  late int code;
  late String message;
  late String status;
  String? pan_name;
  SignUpVerifyPanResponse();
  SignUpVerifyPanResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    pan_name = json['pan_name'];
  }
}