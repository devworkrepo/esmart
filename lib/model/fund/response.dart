import 'bank_list.dart';

class FundRequestBankListResponse {

  FundRequestBankListResponse();

  late int status;
  late String  message;
  List<FundRequestBank>? banks;
  List<String>? notes;

  FundRequestBankListResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    banks = List.from(json['banks']).map((e)=>FundRequestBank.fromJson(e)).toList();
    notes = List.from(json["note"]);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['banks'] = banks?.map((e)=>e.toJson()).toList();
    _data['note'] = notes?.toList();
    return _data;
  }
}
