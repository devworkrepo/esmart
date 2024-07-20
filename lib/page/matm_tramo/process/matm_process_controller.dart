import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/model/matm/matm_request_response.dart';
import 'package:esmartbazaar/page/report/report_helper.dart';
import 'package:esmartbazaar/util/app_util.dart';

import '../../../data/repo/report_repo.dart';
import '../../../model/report/requery.dart';
import '../../response/matm_tramo/matm_txn_response_page.dart';
import '../matm_page.dart';

class MatmProcessController extends GetxController {
  String transactionNumber = Get.arguments["transaction_number"];
  MatmResult result = Get.arguments["result"];

  bool isTimerEnd = false;

  ReportRepo repo = Get.find<ReportRepoImpl>();

  CancelToken? cancelToken;
  @override
  void onInit() {
    super.onInit();
    _startReQuery(16);
  }

  _startReQuery(int delaySecond) async {
    try {
      await Future.delayed(Duration(seconds: delaySecond));

      cancelToken = CancelToken();
      TransactionInfoResponse response = await repo.requeryAepsTransaction(
          {"transaction_no": transactionNumber},
          cancelToken: cancelToken);
      if (response.code == 1) {
        if (!isTimerEnd) {
          if (ReportHelperWidget.getStatusId(response.trans_status) == 1) {
            result.statusId = 1;
            Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
              "response": result,
              "txnType": MatmTramoTransactionType.cashWithdrawal
            });
          } else if (ReportHelperWidget.getStatusId(response.trans_status) ==
              2) {
            result.statusId = 2;
            Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
              "response": result,
              "txnType": MatmTramoTransactionType.cashWithdrawal
            });
          } else {
            if (!isTimerEnd) {
              _startReQuery(5);
            }
          }
        }
      } else {
        result.statusId = 3;
        Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
          "response": result,
          "txnType": MatmTramoTransactionType.cashWithdrawal
        });
      }
    } catch (e) {
      if (e is DioError) {
        if (e.type != DioErrorType.cancel) {
          result.statusId = 3;
          Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
            "response": result,
            "txnType": MatmTramoTransactionType.cashWithdrawal
          });
        }
      } else {
        result.statusId = 3;
        Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
          "response": result,
          "txnType": MatmTramoTransactionType.cashWithdrawal
        });
      }
    }
  }

  onTimerEnd() {
    isTimerEnd = true;
    result.statusId = 3;
    cancelToken?.cancel();
    Get.offAll(() => MatmTramoTxnResponsePage(), arguments: {
      "response": result,
      "txnType": MatmTramoTransactionType.cashWithdrawal
    });
  }

  @override
  void dispose() {
    if (!(cancelToken?.isCancelled ?? true)) {
      cancelToken?.cancel();
    }
    super.dispose();
  }
}
