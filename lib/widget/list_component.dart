import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/hex_color.dart';
import 'package:esmartbazaar/widget/api_component.dart';

class AppExpandListWidget extends StatelessWidget {
  final key1 = UniqueKey();
  final key2 = UniqueKey();

  final RxBool isExpanded;
  final String? imageName;
  final String? txnNumber;
  final String title;
  final String? titleHeader;
  final String subTitle;
  final String? subTitleHeader;
  final String amount;
  final int statusId;
  final String status;
  final String date;
  final String? closingBalance;
  final List<ListTitleValue> expandList;
  final Widget? actionWidget;
  final Widget? actionWidget2;
  final bool showDivider;

  AppExpandListWidget(
      {this.imageName,
      required this.txnNumber,
      required this.title,
      this.titleHeader,
      required this.subTitle,
      this.subTitleHeader,
      required this.amount,
      required this.statusId,
      this.status = "",
      required this.date,
      this.closingBalance,
      required this.isExpanded,
      required this.expandList,
      this.actionWidget2,
      this.showDivider = true,
      Key? key,
      this.actionWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: (isExpanded.value) ? 16 : 0,
          color: (isExpanded.value) ? Get.theme.primaryColorDark : Colors.white,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (!isExpanded.value)
                      ? SizedBox() /* Row(
                          children: const [
                            SizedBox(
                              width: 8,
                            ),
                            CircleAvatar(
                                child: Icon(Icons.receipt_long_rounded))
                          ],
                        )*/
                      : const SizedBox(),
                  Expanded(
                    child: Container(
                      margin: (isExpanded.value)
                          ? null
                          : const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            _BuildHeaderSection(isExpanded.value,
                                txnNumber: txnNumber,
                                imageName: imageName,
                                title: title,
                                titleHeader: titleHeader,
                                subTitle: subTitle,
                                subTitleHeader: subTitleHeader,
                                amount: amount,
                                closingBalance: closingBalance,
                                statusId: statusId,
                                status: status,
                                date: date),
                            (isExpanded.value)
                                ? const Divider(
                                    color: Colors.grey,
                                  )
                                : const EmptyBox(),
                            _buildExpandedSection(),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              (isExpanded.isFalse)
                  ? Column(
                      children: [
                        if (actionWidget2 != null) actionWidget2!,
                        if (showDivider)
                          const Divider(
                            indent: 10,
                            color: Colors.grey,
                          )
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }

  _buildExpandedSection() {
    return Obx(() => (isExpanded.value)
        ? Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            child: Column(
              key: key1,
              children: [
                ...List.generate(expandList.length, (index) {
                  return Container(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              BuildLeftListWidget(
                                expandList[index].title,
                                color: Colors.white70,
                              ),
                              const BuildDotWidget(
                                color: Colors.white70,
                              ),
                              BuildRightListWidget(
                                expandList[index].value,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        );

                }),
                if (actionWidget == null)
                  const SizedBox()
                else
                  Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      actionWidget!
                    ],
                  )
              ],
            ),
          )
        : SizedBox(key: key2));
  }
}

// ignore: must_be_immutable
class _BuildHeaderSection extends StatelessWidget {
  final bool isExpand;

  final String? imageName;
  final String title;
  final String? txnNumber;
  final String? titleHeader;
  final String subTitle;
  final String? subTitleHeader;
  final String amount;
  final int statusId;
  final String status;
  final String date;
  String? closingBalance;

  _BuildHeaderSection(
    this.isExpand, {
    required this.title,
    required this.txnNumber,
    this.titleHeader,
    this.subTitleHeader,
    required this.subTitle,
    required this.amount,
    required this.statusId,
    required this.closingBalance,
    required this.date,
    this.imageName,
    Key? key,
    required this.status,
  }) : super(key: key);

  _buildTitle() {
    var color = (isExpand) ? Colors.white : Get.theme.primaryColor;
    var subColor = (isExpand) ? Colors.white60 : Colors.grey[500];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        (txnNumber == null)
            ? const SizedBox()
       : Container(
          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
          margin: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.blue.withOpacity(0.1)
          ),
          child: Text(
           "Txn No : "+ txnNumber!,
            maxLines: 2,
            style: Get.textTheme.subtitle2?.copyWith(
                color: color, fontWeight: FontWeight.w500, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        (titleHeader == null)
            ? const SizedBox()
            : Text(
                titleHeader!,
                style: Get.textTheme.caption
                    ?.copyWith(fontWeight: FontWeight.w500,color: subColor),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            maxLines: 2,
            style: Get.textTheme.bodySmall?.copyWith(
                color: color, fontWeight: FontWeight.w600, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        (titleHeader == null)
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Divider(
                  indent: 0,
                  color: subColor,
                ),
              )
      ],
    );
  }

  _buildSubtitle() {
    var color = (isExpand) ? Colors.white70 : Colors.black87;
    var subColor = (isExpand) ? Colors.white60 : Colors.grey[500];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (subTitleHeader == null)
            ? const SizedBox()
            : Text(
                subTitleHeader!,
                style: Get.textTheme.caption
                    ?.copyWith(fontWeight: FontWeight.w500, color: subColor),
              ),
        Text(
          subTitle,
          maxLines: 1,
          style: Get.textTheme.subtitle1?.copyWith(
              fontWeight: FontWeight.w500, fontSize: 14, color: color),
          overflow: TextOverflow.ellipsis,
        ),
        (subTitleHeader == null)
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Divider(
                  indent: 0,
                  color: subColor,
                )),
      ],
    );
  }

  _buildDate() {
    var color = (isExpand) ? Colors.white70 : Colors.black54;
    return Text(
      date,
      maxLines: 1,
      style: Get.textTheme.bodyText2?.copyWith(color: color),
      overflow: TextOverflow.ellipsis,
    );
  }

  _buildAmount() {
    var color = (isExpand) ? Colors.white : Colors.black;
    return Text(
      "₹ " + amount,
      maxLines: 1,
      style: Get.textTheme.subtitle1
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatus() {
    var mStatus = status.trim();
    if (status.trim().isNotEmpty) {
      mStatus = status.trim().replaceAll(" ", "\n");
    } else {
      mStatus = (statusId == 1)
          ? "Success"
          : ((statusId == 2) ? "Failed" : "Pending");
    }
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: (isExpand) ? 8 : 0, vertical: 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Text(
        mStatus,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: Get.textTheme.subtitle1?.copyWith(
            fontSize: 12,
            color: ((statusId == 1 || status == "Credit")
                ? Colors.green
                : ((statusId == 2 || status == "Debit")
                    ? Colors.red
                    : (statusId == 3)
                        ? Colors.yellow[900]
                        : Get.theme.primaryColor))),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  _buildClosingBalance(String? balance) {
    if (balance == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text("Closing ₹ " + balance),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BuildListIcon(imageName),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 2),
                    _buildSubtitle(),
                    const SizedBox(
                      height: 2,
                    ),
                    _buildDate(),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAmount(),
                    _buildStatus(),
                    _buildClosingBalance(closingBalance)
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BuildListIcon extends StatelessWidget {
  final String? imageName;

  const BuildListIcon(this.imageName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (imageName == null)
        ? const EmptyBox()
        : Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: HexColor("ECF8FD"),
                borderRadius: BorderRadius.circular(100)),
            child: Image.asset(
              'assets/image/' + imageName!,
              height: 40,
              color: Get.theme.primaryColorDark,
            ),
          );
  }
}

class BuildLeftListWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final int? fontSize;
  final FontWeight? fontWeight;

  const BuildLeftListWidget(this.title,
      {Key? key, this.color, this.fontSize, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Text(
        title,
        style: Get.textTheme.subtitle1?.copyWith(
          fontSize: (fontSize ?? 14).toDouble(),
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? Colors.black54,
        ),
      ),
    );
  }
}

class BuildDotWidget extends StatelessWidget {
  final Color? color;

  const BuildDotWidget({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "  :  ",
      style: Get.textTheme.subtitle1
          ?.copyWith(color: color ?? Get.theme.primaryColorDark),
    );
  }
}

class BuildRightListWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final int? fontSize;
  final FontWeight? fontWeight;

  const BuildRightListWidget(this.title,
      {Key? key, this.color, this.fontSize, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Text(
        title,
        style: Get.textTheme.subtitle1?.copyWith(
            fontSize: (fontSize ?? 14).toDouble(),
            fontWeight: fontWeight ?? FontWeight.w400,
            color: color ?? Get.theme.primaryColor),
      ),
    );
  }
}

class ListTitleValue {
  String title;
  String value;

  ListTitleValue({required this.title, required this.value});
}
