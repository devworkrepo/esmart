class UpiBank {
  String? bankname;
  String? upi_name;

  UpiBank.fromJson(Map<String, dynamic> json) {
    bankname = json["bankname"].toString();
    upi_name = json["upi_name"];
  }
}


class UpiBankListResponse {
  late String status;
  late int code;
  late String message;
  List<UpiBank>? bankList;

  UpiBankListResponse();

  UpiBankListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    if (json["data"] != null) {
      bankList =
      List<UpiBank>.from(json["data"].map((e) => UpiBank.fromJson(e)));
    }
  }
}