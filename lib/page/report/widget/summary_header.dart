import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/cash_convereter.dart';

class SummaryHeader {
  final String title;
  final String value;
  final bool isRupee;
  final int titleFont;
  final int valueFont;
  final Color? backgroundColor;

  SummaryHeader({
    required this.title,
    required this.value,
    this.isRupee = true,
    this.backgroundColor,
    this.titleFont = 12,
    this.valueFont = 16,
  });
}

class SummaryHeaderWidget extends StatelessWidget {
  final List<SummaryHeader> summaryHeader1;
  final List<SummaryHeader?>? summaryHeader2;
  final String? totalCreditedAmount;
  final String? totalDebitedAmount;
  final String? availableBalance;
  final String? availableBalanceInWord;
  final VoidCallback callback;
  final int? transactionCount;
  final String? totalWithdrawn;
  final String? extraValue1;
  final String balanceTitle;

  const SummaryHeaderWidget(
      {required this.summaryHeader1,
      required this.callback,
      this.summaryHeader2,
      this.totalCreditedAmount,
      this.totalDebitedAmount,
      this.availableBalance,
      this.availableBalanceInWord,
      this.transactionCount,
      this.totalWithdrawn,
      this.extraValue1,
      this.balanceTitle = "Your Available Balance",

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (totalCreditedAmount != null && totalDebitedAmount != null)
              _BuildAmountSectionWidget(totalDebitedAmount, totalCreditedAmount,
                  availableBalance, availableBalanceInWord,balanceTitle),
            Text(
              "Summary",
              style: Get.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...summaryHeader1.map((e) => buildItem(summaryHeader: e))
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...?summaryHeader2?.map((e) => buildItem(summaryHeader: e))
                ],
              ),
            ),
          if(totalWithdrawn!= null && totalWithdrawn!.isNotEmpty)  Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.red[50]
              ),

              child: Text("Total Withdrawal :  ${AppConstant.rupeeSymbol + totalWithdrawn.toString()}",style : Get.textTheme.subtitle2?.copyWith(
                color: Colors.red[700]
              )),
            ),

            if(extraValue1!= null)  Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.grey[100]
              ),

              child: Text(extraValue1.toString(),style : Get.textTheme.subtitle2?.copyWith(
                  color: Colors.grey[700]
              )),
            ),
            const SizedBox(
              height: 16,
            ),

            GestureDetector(
              onTap: () {
                callback();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Transaction ${(transactionCount!=null) ? transactionCount.toString() : ""}",
                      style: Get.textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Get.theme.primaryColor, width: 1)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_sharp,
                          color: Get.theme.primaryColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Filter",
                          style: TextStyle(color: Get.theme.primaryColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildItem({required SummaryHeader? summaryHeader}) {
    if (summaryHeader == null) {
      return const Expanded(flex: 1, child: SizedBox());
    }

    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: (summaryHeader.backgroundColor != null)
            ? BoxDecoration(
                color: summaryHeader.backgroundColor,
                borderRadius: BorderRadius.circular(4))
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[600]!, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                (summaryHeader.isRupee)
                    ? "₹${summaryHeader.value == "null" ? "0" : summaryHeader.value}"
                    : (summaryHeader.value == "null")
                        ? "0"
                        : summaryHeader.value,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: summaryHeader.valueFont.toDouble(),
                    color: (summaryHeader.backgroundColor != null)
                        ? Colors.white
                        : Get.theme.primaryColorDark)),
            const SizedBox(
              height: 8,
            ),
            const Spacer(),
            Text(
              summaryHeader.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: summaryHeader.titleFont.toDouble(),
                color: (summaryHeader.backgroundColor == null)
                    ? Get.theme.primaryColor
                    : Colors.white.withOpacity(0.9),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildAmountSectionWidget extends StatelessWidget {
  final String? totalDebitedAmount;
  final String? totalCreditedAmount;
  final String? availableBalance;
  final String? availableBalanceInWord;
  final String balanceTitle;

  const _BuildAmountSectionWidget(
      this.totalDebitedAmount,
      this.totalCreditedAmount,
      this.availableBalance,
      this.availableBalanceInWord,
      this.balanceTitle,);

  @override
  Widget build(BuildContext context) {
    var appPreference = Get.find<AppPreference>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          balanceTitle,
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "₹ $availableBalance",
          style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green[800]),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          availableBalanceInWord.toString(),
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.green),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            _buildItem(Colors.green[800], "Total Amount\nCredited",
                totalCreditedAmount!),
            SizedBox(
              width: 8,
            ),
            _buildItem(
                Colors.red[800], "Total Amount\nDebited", totalDebitedAmount!),
          ],
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }

  Expanded _buildItem(Color? backgroundColor, String title, String value) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          Text(
            "₹ $value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }
}
