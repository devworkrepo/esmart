class VirtualAccountDetailResponse {
  late int code;
  late String message;
  String? status;
  List<VirtualAccount>? virtualAccountList;

  VirtualAccountDetailResponse();
  VirtualAccountDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];

    if (json["Vici"] != null) {
      virtualAccountList = List.from(json['Vici'])
          .map((e) => VirtualAccount.fromJson(e))
          .toList();
    }

  }
}

class VirtualAccount {
  String? bank_name;
  String? account_no;
  String? ifsc;

  VirtualAccount.fromJson(Map<String, dynamic> json) {
    bank_name = json["bank_name"];
    account_no = json["account_no"];
    ifsc = json["ifsc"];
  }
}

