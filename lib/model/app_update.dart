class NetworkAppUpdateInfo {
  int? code;
  String? delayHour;
  bool? isForce;
  bool? isUpdate;
  String? message;
  String? minVersion;
  String? status;
  String? description;
  String? heading;

  NetworkAppUpdateInfo();

  NetworkAppUpdateInfo.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    delayHour = json["delay_hrs"];
    isForce = json["isforce"];
    isUpdate = json["isupdate"];
    message = json["message"];
    minVersion = json["min_version"];
    status = json["status"];
    description = json["update_desc"];
    heading = json["update_heading"];
  }
}
