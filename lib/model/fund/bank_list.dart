
class FundRequestBank {
  FundRequestBank({
    required this.id,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.messageOne,
    required this.messageTwo,
    required this.bankTransferPlaceHolder,
    this.cashDepositPlaceHolder,
    this.cashCdmPlaceHolder,
    required this.ifscCode,
    required this.charge,
  });
  int? id;
  String? accountNumber;
  String? bankName;
  String? branchName;
  String? messageOne;
  String? messageTwo;
  String? bankTransferPlaceHolder;
  String? cashDepositPlaceHolder;
  String? cashCdmPlaceHolder;
  String? ifscCode;
  String? charge;

  FundRequestBank.fromJson(Map<String, dynamic> json){
    id = json['id'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    messageOne = json['message_one'];
    messageTwo = json['message_two'];
    bankTransferPlaceHolder = json['bank_transfer_place_holder'];
    cashDepositPlaceHolder = json["cash_deposit_place_holder"];
    cashCdmPlaceHolder = json["cash_cdm_place_holder"];
    ifscCode = json['ifsc_code'];
    charge = json['charge'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['account_number'] = accountNumber;
    _data['bank_name'] = bankName;
    _data['branch_name'] = branchName;
    _data['message_one'] = messageOne;
    _data['message_two'] = messageTwo;
    _data['bank_transfer_place_holder'] = bankTransferPlaceHolder;
    _data['cash_deposit_place_holder'] = cashDepositPlaceHolder;
    _data['cash_cdm_place_holder'] = cashCdmPlaceHolder;
    _data['ifsc_code'] = ifscCode;
    _data['charge'] = charge;
    return _data;
  }
}