class CmsServiceResponse {
  late int code;
  String? status;
  String? message;
  String? transno;
  String? redirecturl;


  CmsServiceResponse();

  CmsServiceResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    transno = json["transno"];
    redirecturl = json["redirecturl"];

  }

}