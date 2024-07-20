import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/recharge/recharge_plan.dart';

class ProviderResponse {
  late int code;
  late String status;
  late String message;
  String? transactionNumber;
  List<Provider>? providers;

  ProviderResponse();

  ProviderResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    transactionNumber = json['transaction_no'];
    if (json['opelist'] != null) {
      providers =
          List<Provider>.from(json["opelist"].map((e) => Provider.fromJson(e)));
    }
  }
}

class RechargePlanResponse {
  late int status;
  late String message;
  List<RechargePlan>? data;

  RechargePlanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = List<RechargePlan>.from(
        json['data'].map((i) => RechargePlan.fromJson(i)));
  }
}

class BillInfoResponse{


  late int code;
  late String status;
  String? message;
  String? transactionNumber;
  String? name;
  String? billInfo;
  String? billDate;
  String? dueDate;
  String? amount;
  String? operatorCode;
  bool? isPart;

  BillInfoResponse();

  BillInfoResponse.fromJson(Map<String,dynamic> json){

    code = json["code"];
    status = json["status"];
    message = json["message"];
    transactionNumber = json["transaction_no"];
    operatorCode = json["operatorcode"];
    name = json["name"];
    billInfo = json["billinfo"];
    billDate = json["billdate"];
    dueDate = json["duedate"];
    amount = json["amount"];
    isPart = json["ispart"];
  }
}

class RechargeCircleResponse {
  late int code;
  late String status;
  late String message;
  List<RechargeCircle>? circles;

  RechargeCircleResponse();

  RechargeCircleResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];

    code = json['code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      circles = List<RechargeCircle>.from(
          json["data"].map((e) => RechargeCircle.fromJson(e)));
    }
  }
}
