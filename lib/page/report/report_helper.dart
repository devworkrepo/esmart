import 'package:flutter/material.dart';
import 'package:esmartbazaar/widget/button.dart';

import '../../widget/dialog/status_dialog.dart';

enum TransactionReportType {
  ledger,
  aeps,
  aepsAll,
  settlement,
  dmt,
  upi,
  billPayment,
  recharge

}

class ReportHelperWidget{

  static void requeryStatus(String transactionStatus,String message,VoidCallback callback) async{

      int transStatus = ReportHelperWidget.getStatusId(
          (transactionStatus.isEmpty)
              ? "InProgress"
              : transactionStatus);
      if (transStatus == 1) {
        StatusDialog.success(title: message)
            .then((value) => callback());
      } else if (transStatus == 2) {
        StatusDialog.failure(title: message)
            .then((value) => callback());
      } else if (transStatus == 3) {
        StatusDialog.pending(title: message)
            .then((value) => callback());
      }
      else if (transStatus == 4) {
        StatusDialog.pending(title: message)
            .then((value) => callback());
      }

  }

 static int getStatusId(String? status) {
    if (status == null) {
      return 0;
    } else if (status.toLowerCase() == "declined" ||
        status.toLowerCase() == "failed" ||
        status.toLowerCase() == "failure" ||
        status.toLowerCase() == "cancel" ||
        status.toLowerCase() == "declined" ||
        status.toLowerCase() == "reject"
    ) {
      return 2;
    } else if (status.toLowerCase() == "accepted" ||
        status.toLowerCase() == "accept" ||
        status.toLowerCase() == "success" ||
        status.toLowerCase() == "successful" ||
        status.toLowerCase() == "credited" ||
        status.toLowerCase() == "credit"
    ) {
      return 1;
    } else if (status.toLowerCase() == "initiated" ||
        status.toLowerCase() == "refunded" ||
        status.toLowerCase() == "reversed" ||
        status.toLowerCase() == "inprogress"
    ) {
      return 4;
    } else if(status.toLowerCase() == "pending") {
      return 3;
    }
    else {
      return 3;
    }
  }

}

class BuildComplainAndPrintWidget extends StatelessWidget {
  final bool? print;
  final bool? complain;
  final bool? checkStatus;
  final VoidCallback? onComplainClick;
  final VoidCallback? onPrintClick;
  final VoidCallback? onCheckStatusClick;

  const BuildComplainAndPrintWidget(
      {Key? key,
      this.print = false,
      this.complain = false,
      this.checkStatus = false,
      this.onComplainClick,
      this.onPrintClick,
      this.onCheckStatusClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (complain ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(text: "Complaint", onClick: onComplainClick),
              ))
            : const SizedBox(),
        (print ?? false)
            ? const SizedBox(
                width: 16,
              )
            : const SizedBox(),
        (print ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(text: "Print", onClick: onPrintClick),
              ))
            : const SizedBox(),
        (checkStatus ?? false)
            ? const SizedBox(
                width: 16,
              )
            : const SizedBox(),
        (checkStatus ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(
                    text: "Check Status", onClick: onCheckStatusClick),
              ))
            : const SizedBox()
      ],
    );
  }
}
