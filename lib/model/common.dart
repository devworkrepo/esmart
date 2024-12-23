class CommonResponse {
  late int code;
  late String status;
  late String message;
  String? transactionNumber;
  String? transactionStatus;
  String? transResponse;
  bool? kyc_dmt;
  String? refid;

  String? ekycid;
  String? ekyccode;
  String? remitterid;
  String? otpcode;
  String? verifycode;


  CommonResponse();

  CommonResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    transactionNumber = json["transaction_no"];
    transactionStatus  = json["trans_status"];
    transResponse  = json["trans_response"];
    kyc_dmt  = json["kyc_dmt"];
    refid  = json["refid"];
    ekycid  = json["ekycid"];
    ekyccode  = json["ekyccode"];
    remitterid  = json["remitterid"];
    otpcode  = json["otpcode"];
    verifycode  = json["verifycode"];


  }

}


class StatusMessageResponse {
  late int status;
  late String message;
  String? state;


  StatusMessageResponse();

  StatusMessageResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }

  @override
  String toString() {
    return 'CommonResponse{ message: $message, status: $status}';
  }
}
