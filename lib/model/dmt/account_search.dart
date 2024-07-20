class AccountSearchResponse {
  late int code;
  late String message;
  late String status;
  List<AccountSearch>? accounts;

  AccountSearchResponse();

  AccountSearchResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    if (json["beneficiaries"] != null) {
      accounts = List<AccountSearch>.from(
          json["beneficiaries"].map((e) => AccountSearch.fromJson(e)));
    }
  }
}

class AccountSearch {
  String? accountNumber;
  String? bankName;
  String? beneficiaryId;
  String? ifscCode;
  String? holderName;
  String? senderNumber;
  String? validateStatus;

  AccountSearch.fromJson(Map<String, dynamic> json) {
    accountNumber = json["accountno"].toString();
    bankName = json["bank"].toString();
    beneficiaryId = json["beneid"].toString();
    ifscCode = json["ifsc"].toString();
    holderName = json["name"].toString();
    senderNumber = json["remitter_mobile"].toString();
    validateStatus = json["validate_status"].toString();
  }
}
