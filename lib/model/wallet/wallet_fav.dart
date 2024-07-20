class WalletFavListResponse{
  late int code;
  late String message;
  late String status;
  List<WalletFav>? favList;

  WalletFavListResponse();

  WalletFavListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    favList = List.from(json["data"]).map((e) => WalletFav.fromJson(e)).toList();

  }

}

class WalletFav{


  String? agentId;
  String? agentName;
  String? outletName;
  String? outletCode;
  String? mobileNumber;
  String? picName;
  String? favId;

  WalletFav();

  WalletFav.fromJson(Map<String, dynamic> json) {
    agentId = json['agentid'];
    agentName = json['agentname'];
    outletName = json['outletname'];
    outletCode = json['outletcode'];
    mobileNumber = json['mobileno'];
    picName = json['picname'];
    favId = json['favid'];

  }

}


class WalletSearchResponse{
  late int code;
  late String message;
  late String status;
  String? agentId;
  String? agentName;
  String? outletName;
  String? outletCode;
  String? mobileNumber;
  String? picName;
  String? userType;
  String? transactionNumber;

  WalletSearchResponse();

  WalletSearchResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    agentId = json['agentid'];
    agentName = json['agentname'];
    outletName = json['outletname'];
    outletCode = json['outletcode'];
    mobileNumber = json['mobileno'];
    picName = json['picname'];
    userType = json['usertype'];
    transactionNumber = json['transaction_no'];

  }

}



class WalletTransactionResponse{
  late int code;
  late String message;
  late String status;
  String? transactionNumber;
  String? transactionStatus;
  String? transactionResponse;
  //additional
  String? amount;
  String? outletName;
  String? agentName;

  WalletTransactionResponse();


  WalletTransactionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    transactionNumber = json['trans_no'];
    transactionStatus = json['trans_status'];
    transactionResponse = json['trans_response'];

  }

}