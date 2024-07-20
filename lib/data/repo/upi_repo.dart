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
import '../../model/dmt/upi_bank_list.dart';
import '../../model/dmt/upi_mobile_search.dart';
import '../../model/money_request/bank_dertail.dart';

abstract class UpiRepo {
  Future<SenderInfo> searchSender(Map<String, String> data);

  Future<AccountSearchResponse> searchAccount(Map<String, String> data);

  Future<AccountVerifyResponse> verifyAccount(data);
  Future<CommonResponse> addBeneficiary(data);
  Future<CommonResponse> senderRegistration(data);
  Future<CommonResponse> senderRegistrationOtp(data);
  Future<CommonResponse> beneficiaryDelete(data);
  Future<DmtBeneficiaryResponse> fetchBeneficiary(data);
  Future<CalculateChargeResponse> calculatePayoutUpiCharge(data);
  Future<DmtTransactionResponse> transaction(data, CancelToken? cancelToken);
  Future<DmtTransactionResponse> transactionDirect(data, CancelToken? cancelToken);
  Future<UpiBankListResponse> upiBankList();

  Future<CommonResponse> fetchTransactionNumber();
  Future<UpiMobileUpiResponse> searchUpiListWithMobile(data);


}
