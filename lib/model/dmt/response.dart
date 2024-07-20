import 'package:esmartbazaar/model/dmt/bank.dart';
import 'package:esmartbazaar/model/dmt/beneficiary.dart';
import 'package:esmartbazaar/model/dmt/check_status.dart';


class DmtBeneficiaryResponse {
  late int code;
  late String status;
  late String message;
  List<Beneficiary>? beneficiaries;

  DmtBeneficiaryResponse();

  DmtBeneficiaryResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    if (json["beneficiaries"] != null) {
      beneficiaries = List<Beneficiary>.from(
          json["beneficiaries"].map((i) => Beneficiary.fromMap(i)));
    }
  }
}

class DmtBankListResponse {
  late int status;
  late String message;
  List<DmtBank>? bankList;

  DmtBankListResponse();

  DmtBankListResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    if (json["bank_list"] != null) {
      bankList =
          List<DmtBank>.from(json["bank_list"].map((e) => DmtBank.fromJson(e)));
    }
  }
}



class AccountVerifyResponse {
  late int code;
  late String status;
  late String message;
  String? beneficiaryName;

  AccountVerifyResponse();

  AccountVerifyResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    beneficiaryName = json["bene_name"];
  }
}


class DmtTransactionResponse {
  late int code;
  late String message;
  late String status;
  String? senderNumber;
  String? beneficiaryName;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? transactionType;
  List<DmtTransaction>? transactionList;

  DmtTransactionResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    bankName = json["bank"];
    beneficiaryName = json["bene_name"];
    ifscCode = json["ifsc"];
    accountNumber = json["account_no"];
    senderNumber = json["remitter_mobile"];
    transactionType = json["trans_type"];
    if (json["translist"] != null) {
      transactionList = List<DmtTransaction>.from(
          json["translist"].map((e) => DmtTransaction.fromJson(e)));
    }
  }
}

class DmtTransaction {
  String? serialNumber;
  String? amount;
  String? charge;
  String? transactionNumber;
  String? bankTransactionId;
  String? transactionStatus;
  String? transactionResponse;

  DmtTransaction.fromJson(Map<String, dynamic> json) {
    serialNumber = json["srno"].toString();
    amount = json["amount"].toString();
    charge = json["charge"].toString();
    bankTransactionId = json["bank_txnid"].toString();
    transactionNumber = json["transaction_no"].toString();
    transactionStatus = json["trans_status"].toString();
    transactionResponse = json["trans_response"].toString();
  }
}

class DmtCheckStatusResponse {
  late int status;
  late String message;
  String? orderId;
  DmtCheckStatus? dmtCheckStatus;

  DmtCheckStatusResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    orderId = json["orderId"];
    if (json["data"] != null) {
      dmtCheckStatus = DmtCheckStatus.fromJson(json["data"]);
    }
  }
}