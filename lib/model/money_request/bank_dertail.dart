class BankTypeDetailResponse{
  late int code;
  late String message;
  late String status;
  String? transactionNumber;
  List<MoneyRequestType>? typeList;
  List<MoneyRequestBank>? accountList;


  BankTypeDetailResponse();

  BankTypeDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    transactionNumber = json['transaction_no'];
    typeList = List.from(json["typelist"]).map((e) => MoneyRequestType.fromJson(e)).toList();
    accountList = List.from(json["acclist"]).map((e) => MoneyRequestBank.fromJson(e)).toList();
  }

}

class MoneyRequestType{
  String? name;

  MoneyRequestType();

  MoneyRequestType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

class MoneyRequestBank{
  String? name;
  MoneyRequestBank();

  MoneyRequestBank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}



class BondResponse {
  late int code;
  late String status;
  late String message;
  String? content;


  BondResponse();

  BondResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'].toString();
    code = json["code"];
    content = json["bondcontent"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}