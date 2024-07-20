class MoneyReceiptResponse {
  late int code;
  String? accountNumber;
  String? date;
  String? amountInWords;
  String? bank;
  String? beneficiaryName;
  String? ifscCode;
  String? message;
  String? outletMobile;
  String? outletName;
  String? senderNumber;
  String? senderName;
  String? status;
  String? totalAmount;
  String? transactionType;
  List<MoneyReceiptDetail>? moneyReceiptDetail;

  MoneyReceiptResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    accountNumber = json["account_no"];
    date = json["addeddate"];
    amountInWords = json["amountwords"];
    bank = json["bank"];
    beneficiaryName = json["bene_name"];
    ifscCode = json["ifsc"];
    message = json["message"];
    outletMobile = json["outlet_mobile"];
    outletName = json["outlet_name"];
    senderNumber = json["remitter_mobile"];
    senderName = json["remitter_name"];
    status = json["status"];
    totalAmount = json["totalamount"].toString();
    transactionType = json["trans_type"];
    moneyReceiptDetail = List.from(json["translist"])
        .map((e) => MoneyReceiptDetail.fromJson(e))
        .toList();
  }
}

class MoneyReceiptDetail {
  String? amount;
  String? bankTxnId;
  String? charge;
  String? serialNumber;
  String? transactionResponse;
  String? transactionStatus;
  String? transactionNumber;

  MoneyReceiptDetail.fromJson(Map<String, dynamic> json) {
    amount = json["amount"].toString();
    bankTxnId = json["bank_txnid"].toString();
    charge = json["charge"].toString();
    serialNumber = json["srno"].toString();
    transactionResponse = json["trans_response"];
    transactionStatus = json["trans_status"];
    transactionNumber = json["transaction_no"];
  }
}
