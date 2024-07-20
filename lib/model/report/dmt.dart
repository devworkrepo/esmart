import 'package:get/get.dart';

class MoneyReportResponse {
  late int code;
  late String status;
  late String message;
  List<MoneyReport>? reports;

  MoneyReportResponse();

  MoneyReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    if(json["translist"] != null){
      reports =
          List.from(json['translist']).map((e) => MoneyReport.fromJson(e)).toList();
    }
  }
}








class MoneyReport {


  String? calcId;
  String? transactionNumber;
  String? senderNubber;
  String? beneficiaryName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? amount;
  String? charge;
  String? commission;
  String? transactionType;
  String? utrNumber;
  String? transactionStatus;
  String? transactionMessage;
  String? date;

  RxBool isExpanded = false.obs;

  MoneyReport.fromJson(Map<String, dynamic> json){
     calcId = json['calcid'];
     transactionNumber = json['transaction_no'];
     senderNubber = json['remitter_mobile'];
     bankName = json['bank'];
     beneficiaryName = json['bene_name'];
     accountNumber = json['account_no'];
     ifscCode = json['ifsc'];
     amount = json['amount'].toString();
     charge = json['charge'].toString();
     commission = json['commision'].toString();
     transactionType = json['trans_type'];
     utrNumber = json['utr_no'];
     transactionStatus = json['trans_status'];
     transactionMessage = json['trans_message'];
     date = json['addeddate'];

  }

}
