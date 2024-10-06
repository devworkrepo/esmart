class UserDetail {

  late int code;
  late String message;
  late String status;
  String? agentId;
  String? fullName;
  String? outletName;
  String? picName;
  String? agentCode;
  String? userType;
  String? availableBalance;
  String? openBalance;
  String? creditBalance;
  bool? isPayoutBond;
  bool? isInstantPay;
  bool? isWalletPay;
  bool? isRecharge;
  bool? isDth;
  bool? isVirtualAccount;
  bool? isSecurityDeposit;
  bool? isInsurance;
  bool? isBill;
  bool? isCreditCard;
  bool? isPaytmWallet;
  bool? isLic;
  bool? isOtt;
  bool? isBillPart;
  bool? isPayout;
  bool? isAeps;
  bool? isAadhaarPay;
  bool? isMatm;
  bool? isLoginResendOtp;
  bool? isMoneyRequest;
  bool? is_mpos_credo;
  bool? is_matm_credo;
  bool? is_aeps_air;
  bool? isAEPS_F;
  bool? allow_local_apk;
  bool? is_pg;
  bool? is_cms;
  bool? isQR;
  bool? isUpi;



  UserDetail();

  UserDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    agentId = json['agentid'];
    fullName = json["fullname"];
    outletName = json["outlet_name"];
    picName = json['picname'];
    agentCode = json['agentcode'];
   userType = json['usertype'];

    //userType = "SM";
    isPayout = json['is_payout'];
    availableBalance = json['availbalance'].toString();
    openBalance = json['openbalance'].toString();
    creditBalance = json['creditbalance'].toString();
    isPayoutBond = json['is_payout_bond'];
    isWalletPay = json['isSmartPay'];
    isRecharge = json['isRecharges'];
    isDth = json['isDTH'];
    isInsurance = json['isInsurance'];
    isInstantPay = json['is_instantpay'];
    isBill = json['isBill_TRM'];
    isVirtualAccount = json['isVirtualAcc'];
    isSecurityDeposit = json['is_security_deposit'];
    isCreditCard = json['isCreditBill'];
    isPaytmWallet = json['is_paytmwallet'];
    isLic = json['is_lic'];
    isOtt = json['isOTT'];
    isBillPart = json['isBill_PART'];
    isAeps = json['isAEPS_T'];
    isAadhaarPay = json["isAadharPay_T"];
    isMatm = json['is_matm'];
    isMoneyRequest = json['is_moneyrequest'];
    is_mpos_credo = json['is_mpos_credo'];
    is_matm_credo = json['is_matm_credo'];
    is_aeps_air = json['is_aeps_air'];
    is_pg  = json['is_PG_Active'];
    is_cms  = json['isCMS'];
    allow_local_apk = json['allow_local_apk'];
    isQR = json['isQR'];
    isUpi = json['isUPI'];
    isAEPS_F = json['isAEPS_F'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data ['code']=code;
    data ['message']=message;
    data ['status']=status;
    data ['agentid']=agentId;
    data ["fullname"]=fullName;
    data ["outlet_name"]=outletName;
    data ['picname']=picName;
    data ['agentcode']=agentCode;
    data ['usertype']=userType;
    data ['availbalance']=availableBalance;
    data ['openbalance']=openBalance;
    data ['creditbalance']=creditBalance;
    data ['is_payout_bond']=isPayoutBond;
    data ['is_payout']=isPayout;
    data ['isSmartPay']=isWalletPay;
    data ['is_instantpay']=isInstantPay;
    data ['isRecharges']=isRecharge;
    data ['isDTH']=isDth;
    data ['isInsurance']=isInsurance;
    data ['isBill_TRM']=isBill;
    data ['isCreditBill']=isCreditCard;
    data ['is_paytmwalle']=isPaytmWallet;
    data ['is_lic']=isLic;
    data ['isOTT']=isOtt;
    data ['isVirtualAcc']=isVirtualAccount;
    data ['is_security_deposit']=isSecurityDeposit;
    data ['isBill_PART']=isBillPart;
    data ['isAEPS_T']=isAeps;
    data ['isAadharPay_T']=isAadhaarPay;
    data ['is_matm']=isMatm;
    data ['is_moneyrequest']=isMoneyRequest;
    data ['is_mpos_credo']=is_mpos_credo;
    data ['is_matm_credo']=is_matm_credo;
    data ['is_aeps_air']=is_aeps_air;
    data ['is_PG_Active']=is_pg;
    data ['isCMS']=is_cms;
    data ['allow_local_apk']=allow_local_apk;
    data ['isQR']=isQR;
    data ['isUpi']=isUpi;
    data ['isAEPS_F']=isAEPS_F;
    return data;
  }



}

class UserBalance{
  late int status;
  String? wallet;

  UserBalance();

  UserBalance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    wallet = json['wallet'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['wallet'] = wallet;
    return data;
  }


}



class KycDetails {

  String? isPanKyc;
  String? isAadhaarKyc;
  String? isDocumentKyc;
  String? isAepsKyc;

  KycDetails.fromJson(Map<String, dynamic> json){
    isPanKyc = json['is_pan_kyc'];
    isAadhaarKyc = json['is_aadhaar_kyc'];
    isDocumentKyc = json['is_document_kyc'];
    isAepsKyc = json['is_aeps_kyc'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['is_pan_kyc'] = isPanKyc;
    _data['is_aadhaar_kyc'] = isAadhaarKyc;
    _data['is_document_kyc'] = isDocumentKyc;
    _data['is_aeps_kyc'] = isAepsKyc;
    return _data;
  }

  @override
  String toString() {
    return 'KycDetails{isPanKyc: $isPanKyc, isAadhaarKyc: $isAadhaarKyc, isDocumentKyc: $isDocumentKyc, isAepsKyc: $isAepsKyc}';
  }
}