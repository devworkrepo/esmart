class AepsBank{
  String? id;
  String? name;

  AepsBank._();

  AepsBank.fromJson(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
  }
}

class AepsBankResponse {
  late int code;
  String? status;
  String? message;
  String? transactionNumber;
  String? bcid;
  String? lat;
  String? lng;
  bool? isEKcy;
  List<AepsBank>? aepsBankList;

  AepsBankResponse();

  AepsBankResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transactionNumber = json["transaction_no"];
    bcid = json["bcid"];
    lat = json["lat"];
    lng = json["lng"];
    isEKcy = json["isekyc"];
    if (json["banklist"] != null) {
      aepsBankList = List<AepsBank>.from(
          json["banklist"].map((e) => AepsBank.fromJson(e)));
    }
  }
}