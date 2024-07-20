import 'package:dio/dio.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/recharge/bill_payment.dart';
import 'package:esmartbazaar/model/recharge/extram_param.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/recharge/recharge.dart';
import 'package:esmartbazaar/model/recharge/recharge_plan.dart';
import 'package:esmartbazaar/model/recharge/response.dart';
import 'package:esmartbazaar/model/report/requery.dart';

import '../../model/ott/ott_operator.dart';
import '../../model/ott/ott_plan.dart';
import '../../model/paytm_wallet/paytm_wallet.dart';
import '../../model/recharge/credit_card.dart';

abstract class RechargeRepo{

  Future<ProviderResponse> fetchProviders(Map<String,String> data);
  Future<RechargeCircleResponse> fetchCircles(Map<String,String> data);
  Future<RechargeResponse> makeMobilePrepaidRecharge(Map<String,String> data, CancelToken? cancelToken);
  Future<RechargeResponse> makeDthRecharge(Map<String,String> data, CancelToken? cancelToken);
  Future<RechargeResponse> makeMobilePostpaidRecharge(Map<String,String> data, CancelToken? cancelToken);

  //bill payment

  Future<BillExtraParamResponse> fetchExtraParam(data);
  Future<BillInfoResponse> fetchBillInfo(data);
  Future<BillInfoResponse> fetchLicBillInfo(data);
  Future<BillPaymentResponse> makeOfflineBillPayment(data, CancelToken? cancelToken);
  Future<BillPaymentResponse> makePartBillPayment(data, CancelToken? cancelToken);
  Future<BillPaymentResponse> makeLicOnlineBillPayment(data, CancelToken? cancelToken);

  //card
  Future<BankListResponse> fetchCreditCardBank();
  Future<CreditCardTypeResponse> fetchCreditCardType();
  Future<CreditCardLimitResponse> fetchCreditLimit(data);
  Future<CommonResponse> fetchTransactionNumber();
  Future<CreditCardPaymentResponse> makeCardPayment(data, CancelToken? cancelToken);

  //paytm load

  Future<TransactionInfoResponse> verifyPaytmWallet(data);
  Future<PaytmLoadTransactionResponse> paymtWalletLoadTransaction(data);

  //ott
  Future<OttOperatorListResponse> fetchOttOperators();
  Future<OttPlanResponse> fetchOttPlan(data);
  Future<RechargeResponse> ottTransaction(data);




}