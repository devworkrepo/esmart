import 'package:dio/dio.dart';
import 'package:esmartbazaar/model/bank.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';
import 'package:esmartbazaar/model/dmt/calculate_charge.dart';
import 'package:esmartbazaar/model/dmt/response.dart';
import 'package:esmartbazaar/model/dmt/sender_info.dart';
import 'package:esmartbazaar/model/dmt/sender_kyc.dart';
import 'package:esmartbazaar/model/dmt/verification_charge.dart';

import '../../model/dmt/kyc_info.dart';
import '../../model/money_request/bank_dertail.dart';

abstract class DmtRepo {
  Future<SenderInfo> searchSender(Map<String, String> data);
  Future<SenderInfo> searchSenderDmt2(Map<String, String> data);
  Future<SenderInfo> searchSenderDmt3(Map<String, String> data);
  Future<BondResponse> fetchPayoutBond();
  Future<AccountSearchResponse> searchAccount(Map<String, String> data);
  Future<AccountSearchResponse> searchAccountDmt2(Map<String, String> data);

  Future<BankListResponse> fetchBankList();

  Future<AccountVerifyResponse> verifyAccount(data);

  Future<KycInfoResponse> kycInfo(data);

  Future<DmtBeneficiaryResponse> fetchBeneficiary(Map<String, String> data);

  Future<CommonResponse> addBeneficiary(Map<String, String> data);
  Future<CommonResponse> syncBeneficiary(Map<String, String> data);

  Future<CommonResponse> senderRegistration(Map<String, String> data);
  Future<CommonResponse> senderRegistration2(Map<String, String> data);
  Future<CommonResponse> senderRegistration3(Map<String, String> data);

  Future<CommonResponse> senderRegistrationOtp(Map<String, String> data);
  Future<CommonResponse> senderRegistrationOtp2(Map<String, String> data);
  Future<CommonResponse> senderRegistrationOtp3(Map<String, String> data);
  Future<CommonResponse> senderRegistrationKyc(Map<String, String> data);
  Future<CommonResponse> senderRegistrationKycDmt3(Map<String, String> data);

  Future<CalculateChargeResponse> calculateNonKycCharge(
      Map<String, String> data);

  Future<CalculateChargeResponse> calculateKycCharge(Map<String, String> data);
  Future<CalculateChargeResponse> calculateKycCharge2(Map<String, String> data);
  Future<CalculateChargeResponse> calculateKycCharge3(Map<String, String> data);

  Future<CalculateChargeResponse> calculatePayoutCharge(
      Map<String, String> data);

  Future<DmtCheckStatusResponse> transactionCheckStatus(
      Map<String, String> data);

  Future<CommonResponse> beneficiaryDelete(Map<String, String> data);

  Future<DmtVerificationChargeResponse> accountVerificationCharge();

  Future<CommonResponse> changeSenderName(data);

  Future<CommonResponse> changeSenderMobile(data);

  Future<CommonResponse> changeSenderOtp(data);

  Future<DmtTransactionResponse> nonKycTransaction(
      Map<String, String> data, CancelToken? cancelToken);

  Future<DmtTransactionResponse> kycTransaction(
      Map<String, String> data, CancelToken? cancelToken);

  Future<DmtTransactionResponse> dmt2Transaction(
      Map<String, String> data, CancelToken? cancelToken);
  Future<DmtTransactionResponse> dmt3Transaction(
      Map<String, String> data, CancelToken? cancelToken);

  Future<DmtTransactionResponse> payoutTransaction(
      Map<String, String> data, CancelToken? cancelToken);

  Future<DmtBeneficiaryResponse> fetchDeletedBeneficiary(
      Map<String, String> data);

  Future<CommonResponse> importRemitterBeneficiary(Map<String, String> data);

  Future<CommonResponse> importDeletedBeneficiary(Map<String, String> data);

  //sender kyc

  Future<SenderKycCaptcha> senderKycCaptcha(data);

  Future<SenderKycCaptcha> senderKycReCaptcha(data);

  Future<CommonResponse> senderKycSendOtp(data);
  Future<CommonResponse> sendDmt2TransactionOtp(data);
  Future<CommonResponse> sendDmt3TransactionOtp(data);
  Future<CommonResponse> verifyDmt3TransactionOtp(data);
  Future<CommonResponse> senderKycReSendOtp(data);
  Future<CommonResponse> senderKycVerifyOtp(data);
  Future<CommonResponse> checkDmtKycStatus();
}
