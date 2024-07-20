import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/investment/Investment_close_calc.dart';
import 'package:esmartbazaar/model/investment/inventment_balance.dart';
import 'package:esmartbazaar/model/investment/inventment_calc.dart';
import 'package:esmartbazaar/model/investment/investment_list.dart';
import 'package:esmartbazaar/model/investment/investment_summary.dart';
import 'package:esmartbazaar/model/user/signup/mobile_submit.dart';
import 'package:esmartbazaar/model/wallet/wallet_fav.dart';
import 'package:dio/dio.dart' as dio;

import '../../model/report/security_deposit.dart';

abstract class SecurityDepositRepo{

  //security deposit
  Future<CommonResponse> addDeposit(data);
  Future<SecurityDepositReportResponse> fetchReport(data);

  //new investment
  Future<InvestmentBalanceResponse> fetchInvestmentBalance();
  Future<InvestmentCalcResponse> fetchInvestmentCalc(data);
  Future<InvestmentListResponse> fetchInvestmentLists(data);
  Future<InvestmentCloseCalcResponse> fetchCloseCalc(data);
  Future<CommonResponse> closeInvestment(data);
  Future<InvestmentSummaryResponse> fetchSummary();
  Future<CommonResponse> checkPanDetail();
  Future<CommonResponse> uploadPanDetail(dio.FormData data);
  Future<CommonResponse> createInvestment(data);
}