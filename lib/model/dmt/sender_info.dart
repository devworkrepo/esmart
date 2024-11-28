import 'package:get/get.dart';

class SenderInfo{

        late int code;
        late String message;
        late String status;
        bool? isKycVerified;
        bool? iskycimps;
        bool? iskycneft;
        bool? showNonKycDetail;
        String? impsKycLimitAll;
        String? impsKycLimitView;
        String? impsNKycLimitAll;
        String? impsNKycLimitView;
        String? neftKycLimitAll;
        String? neftKycLimitView;
        String? neftLimit;
        String? neftNKycLimitAll;
        String? neftNKycLimitView;
        String? payoutMin;
        String? payoutPer;
        String? payoutTotal;
        String? quickPayLimit;
        String? walletOneLimit;
        String? walletTwoLimit;
        String? walletThreeLimit;
        String? senderName;
        String? senderNumber;
        String? senderId;
        String? upi_limit;
        String? perentry_limit;


        bool? isname;
        bool? isotp;
        bool? isekyc;
        String? first_name;
        String? last_name;

        SenderInfo.fromJson(Map<String,dynamic> json){
                code = json["code"];
                message = json["message"].toString();
                status = json["status"].toString();
                isKycVerified = json["iskycverified"];
                iskycimps = json["iskycimps"];
                iskycneft = json["iskycneft"];
                impsKycLimitAll = json["imps_kyclimit_all"].toString();
                impsKycLimitView = json["imps_kyclimit_view"].toString();
                impsNKycLimitAll = json["imps_nkyclimit_all"].toString();
                impsNKycLimitView = json["imps_nkyclimit_view"].toString();
                neftKycLimitAll = json["neft_kyclimit_all"].toString();
                neftKycLimitView = json["neft_kyclimit_view"].toString();
                neftLimit = json["neft_limit"].toString();
                neftNKycLimitAll = json["neft_nkyclimit_all"].toString();
                neftNKycLimitView = json["neft_nkyclimit_view"].toString();
                payoutMin = json["payout_min"].toString();
                payoutPer = json["payout_per"].toString();
                payoutTotal = json["payout_total"].toString();
                quickPayLimit = json["quickpay_limit"].toString();
                walletOneLimit = json["wallet_1_limit"].toString();
                walletTwoLimit = json["wallet_2_limit"].toString();
                walletThreeLimit = json["wallet_3_limit"].toString();
                senderName = json["remittername"];
                senderNumber = json["mobileno"];
                senderId = json["remitterid"];
                upi_limit = json["upi_limit"].toString();
                perentry_limit = json["perentry_limit"].toString();
                isname = json["isname"] ?? false;
                isotp = json["isotp"] ?? false;
                isekyc = json["isekyc"] ?? false;
                first_name = json["first_name"] ?? "";
                last_name = json["last_name"] ?? "";


        }



}