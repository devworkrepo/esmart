class PrintReceiptResponse {

  late final int status;
  late final String message;
  PrintReceipt? data;

  PrintReceiptResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = PrintReceipt.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class PrintReceipt {

 String? beneficiaryName;
 String? bankName;
 String? accountNumber;
 String? shopContact;
 String? prefix;
 int? amount;
 String? txnId;
 String? bankRefNo;
 String? status;
 String? ifscCode;
 String? senderMobile;
 String? senderName;
 String? walletName;
 String? serviceProvider;
 String? shopName;
 String? shopAddress;
 String? shopContactNumber;
 String? companyAddress;
 int? recieptNo;
 String? createdAt;
 String? transactionType;//////
 String? billerName;
 String? customerMobNO;
 String? consumerIdNo;
 String? paymentMode;
 String? paymentChannel;

  PrintReceipt.fromJson(Map<String, dynamic> json){
    beneficiaryName = json['beneficiaryName'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    shopContact = json['shopContact'];
    prefix = json['prefix'];
    amount = json['amount'];
    txnId = json['txnId'];
    bankRefNo = json['bankRefNo'];
    status = json['status'];
    ifscCode = json['ifscCode'];
    senderMobile = json['senderMobile'];
    senderName = json['senderName'];
    walletName = json['walletName'];
    serviceProvider = json['serviceProvider'];
    shopName = json['shopName'];
    shopAddress = json['shopAddress'];
    shopContactNumber = json['shopContactNumber'];
    companyAddress = json['companyAddress'];
    recieptNo = json['recieptNo'];
    createdAt = json['createdAt'];
    transactionType = json['transactionType'];
    billerName = json['billerName'];
    customerMobNO = json['customerMobNO'];
    consumerIdNo = json['consumerIdNo'];
    paymentMode = json['paymentMode'];
    paymentChannel = json['paymentChannel'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['beneficiaryName'] = beneficiaryName;
    _data['bankName'] = bankName;
    _data['accountNumber'] = accountNumber;
    _data['shopContact'] = shopContact;
    _data['prefix'] = prefix;
    _data['amount'] = amount;
    _data['txnId'] = txnId;
    _data['bankRefNo'] = bankRefNo;
    _data['status'] = status;
    _data['ifscCode'] = ifscCode;
    _data['senderMobile'] = senderMobile;
    _data['senderName'] = senderName;
    _data['walletName'] = walletName;
    _data['serviceProvider'] = serviceProvider;
    _data['shopName'] = shopName;
    _data['shopAddress'] = shopAddress;
    _data['shopContactNumber'] = shopContactNumber;
    _data['companyAddress'] = companyAddress;
    _data['recieptNo'] = recieptNo;
    _data['createdAt'] = createdAt;
    _data['transactionType'] = transactionType;
    _data['billerName'] =billerName;
    _data['customerMobNO'] =customerMobNO;
    _data['consumerIdNo'] =consumerIdNo;
    _data['paymentMode'] =paymentMode;
    _data['paymentChannel'] =paymentChannel;
    return _data;
  }
}
