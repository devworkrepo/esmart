class AlertMessageResponse {
  late int code;
  String? status;
  String? message;
  String? alert_no;


  AlertMessageResponse();

  AlertMessageResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    alert_no = json["alert_no"];
  }

}