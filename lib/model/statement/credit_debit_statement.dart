

import 'package:flutter/material.dart';

class CreditDebitStatementResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<CreditDebitStatement>? reportList;

  CreditDebitStatementResponse();

  CreditDebitStatementResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => CreditDebitStatement.fromJson(e))
          .toList();
    }
  }
}

class CreditDebitStatement {
  String? date;
  String? refno;
  String? type;
  String? narration;
  String? remark;
  String? amt;
  String? inAmount;
  String? outAmount;


  CreditDebitStatement.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    narration = json["narration"];
    remark = json["remark"];
    amt = json["amt"].toString();
    type = json["type"];
    refno = json["refno"];
    inAmount = json["in_amt"].toString();
    outAmount = json["out_amt"].toString();
  }

  String getAmount() {
    try {
      var inAmt = (inAmount != null && inAmount!.isNotEmpty) ? double.parse(
          inAmount.toString()) : 0.0;
      var outAmt = (outAmount != null && outAmount!.isNotEmpty) ? double.parse(
          outAmount.toString()) : 0.0;
      var amount = (inAmt > outAmt) ? inAmount.toString() : outAmount
          .toString();
      return amount;
    } catch (e) {
      return inAmount.toString();
    }
  }

  Color getColor() {
    try {
      var inAmt = (inAmount != null && inAmount!.isNotEmpty) ? double.parse(
          inAmount.toString()) : 0.0;
      var outAmt = (outAmount != null && outAmount!.isNotEmpty) ? double.parse(
          outAmount.toString()) : 0.0;
      var color = (inAmt > outAmt) ? Colors.green[800] : Colors.red[800];
      return color!;
    } catch (e) {
      return Colors.black;
    }
  }

}
