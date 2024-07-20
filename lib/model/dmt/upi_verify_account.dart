class UpiAccountVerificationResponse {
  late int status;
  late String message;
  String? beneficiaryName;


  UpiAccountVerificationResponse();

  UpiAccountVerificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    beneficiaryName = json['bane_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['bane_name'] = beneficiaryName;
    return data;
  }
}
