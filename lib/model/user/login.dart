class LoginResponse {

  late int code;
  late String message;
  late String status;
  String? otpKey;
  String? agentId;
  String? sessionKey;
  bool? hideresend;

  LoginResponse();
  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    otpKey = json["otpkey"];
    agentId = json["agentid"];
    hideresend = json["hideresend"];
    sessionKey = json["sessionkey"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data["code"] = code;
    data["otpkey"] = otpKey;
    data["hideresend"] = hideresend;
    data["agentid"] = agentId;
    data["sessionkey"] = sessionKey;
    return data;
  }


}



class ForgotPasswordResponse {
  late int status;
  late String message;
  String? token;


  ForgotPasswordResponse();

  ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['token'] = token;
    return data;
  }
}
