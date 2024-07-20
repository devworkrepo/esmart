class UpiMobileUpi{
  String? vpa_name;
  bool isSelected = false;

  UpiMobileUpi.fromJson(Map<String, dynamic> json) {
    vpa_name = json["vpa_name"].toString();
  }
}


class UpiMobileUpiResponse {
  late String status;
  late int code;
  late String message;

  String? primary_vpa;
  String? bene_name;
  List<UpiMobileUpi>? upiList;

  UpiMobileUpiResponse();

  UpiMobileUpiResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    primary_vpa = json["primary_vpa"];
    bene_name = json["bene_name"];
    if (json["vpas"] != null) {
      upiList =
      List<UpiMobileUpi>.from(json["vpas"].map((e) => UpiMobileUpi.fromJson(e)));
    }
  }
}