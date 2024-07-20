class LoginSessionResponse{
  late int code;
  late String message;
  List<LoginSession>? sessions;

  LoginSessionResponse();
  LoginSessionResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    sessions = List.from(json["data"]).map((e) => LoginSession.fromJson(e)).toList();
  }

}

class LoginSession{


  String? active_id;
  String? device_name;
  String? device_type;
  String? ip_address;
  String? expiry_date;
  String? login_date;


  LoginSession.fromJson(Map<String,dynamic> json){
    active_id = json["active_id"];
    device_name = json["device_name"];
    device_type = json["device_type"];
    ip_address = json["ip_address"];
    expiry_date = json["expiry_date"];
    login_date = json["login_date"];
  }

}