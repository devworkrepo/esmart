
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class RechargeRefundListResponse{
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<RechargeRefund>? reports;
  RechargeRefundListResponse();
  RechargeRefundListResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    if(json["rechlist"] != null){
      reports = List.from(json["rechlist"]).map((e) => RechargeRefund.fromJson(e)).toList();
    }

  }
}

class RechargeRefund{
  String? transactionNumber;
  String? number;
  String? refMobileNumber;
  String? rechargeType;
  String? operatorName;
  String? payId;
  String? operatorRefNumber;
  String? amount;
  String? transactionStatus;
  String? transactionResponse;
  String? date;
  var isExpanded = RxBool(false);

  RechargeRefund.fromJson(Map<String,dynamic> json){
    transactionNumber = json["transaction_no"];
    number = json["mobile_no"];
    refMobileNumber = json["ref_mobile_no"];
    rechargeType = json["rech_type"];
    operatorName = json["operator_name"];
    payId = json["payid"];
    operatorRefNumber = json["operator_refno"];
    amount = json["amount"].toString();
    transactionStatus = json["trans_status"];
    transactionResponse = json["trans_response"];
    date = json["addeddate"];
  }
}