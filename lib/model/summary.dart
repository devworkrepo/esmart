class TransactionSummary {

  String? aadhaarPayInProgress;
  String? aadhaarPayTRF;
  String? aepsInProgress;
  String? aepsMatmTRF;
  late int  code;
  String? creditCardTRF;
  String? creditInProgress;
  String? creditRefundPending;
  String? dmtInProgress;
  String? dmtRefundPending;
  String? fundReceived;
  String? message;
  String? moneyTransfer;
  String? payoutInProgress;
  String? payoutRefundPending;
  String? status;
  String? utilityInProgress;
  String? utilityRefundPending;
  String? utilityTRF;

  TransactionSummary();

  TransactionSummary.fromJson(Map<String,dynamic> json){
    aadhaarPayInProgress = json["aadharpay_inprogress"].toString();
    aadhaarPayTRF = json["aadharpay_trf"].toString();
    aepsInProgress = json["aeps_inprogress"].toString();
    aepsMatmTRF = json["aeps_matm_trf"].toString();
    code = json["code"];
    creditCardTRF = json["credit_card_trf"].toString();
    creditInProgress = json["credit_inprogress"].toString();
    creditRefundPending = json["credit_refundpending"].toString();
    dmtInProgress = json["dmt_inprogress"].toString();
    dmtRefundPending = json["dmt_refundpending"].toString();
    fundReceived = json["fund_received"].toString();
    message = json["message"].toString();
    moneyTransfer = json["money_transfer"].toString();
    payoutInProgress = json["payout_inprogress"].toString();
    payoutRefundPending = json["payout_refundpending"].toString();
    status = json["status"];
    utilityInProgress = json["utility_inprogress"].toString();
    utilityRefundPending = json["utility_refundpending"].toString();
    utilityTRF = json["utility_trf"].toString();
  }


}
