import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/hex_color.dart';

import '../../../../widget/text_field.dart';
import '../beneficiary_controller.dart';

class BeneficiarySenderHeader extends GetView<BeneficiaryListController> {
  final VoidCallback onClick;
  final String mobileNumber;
  final String senderName;
  final String limit;

  const BeneficiarySenderHeader(
      {Key? key,
      required this.onClick,
      required this.mobileNumber,
      required this.senderName,
      required this.limit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(
          top: statusBarHeight + kToolbarHeight, left: 8, right: 8, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_buildCircularAvatar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildName(senderName),
                  SizedBox(height: 3,),
                  _buildName(mobileNumber),
                  SizedBox(height: 3,),
                if((controller.sender!.showNonKycDetail ?? false) == false)  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text("Kyc Customer",style: TextStyle(
                        color: Colors.white
                    ),),
                  ],),
                  const SizedBox(
                    height: 8,
                  ),
                  (controller.sender!.showNonKycDetail == true)
                      ? _buildChangeWidget()
                      : const SizedBox()
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLimitTitleWidget(),
                (controller.dmtType == DmtType.instantPay)
                    ? Obx(() =>
                controller.showAvailableTransferLimitObs.value == true
                    ? _buildLimitBalanceWidget()
                    : _buildViewLimitContainer())
                    : _buildLimitBalanceWidget(),
                _buildNonKycWidget()
              ],
            )
            // _buildAddBeneButton()
          ],
        ),
      ),
    );
  }

  Text _buildLimitBalanceWidget() {
    if (controller.dmtType == DmtType.payout) {
      return Text(
        "₹ ${controller.sender!.payoutPer.toString()}",
        style: Get.textTheme.headline3?.copyWith(color: Colors.green),
      );
    }

    return Text(
      "₹ ${(controller.sender!.isKycVerified ?? false) ? controller.sender?.impsKycLimitView : controller.sender?.impsNKycLimitView}",
      style: Get.textTheme.headline3?.copyWith(color: Colors.green),
    );
  }

  SingleChildRenderObjectWidget _buildNonKycWidget() {
    return (controller.dmtType == DmtType.instantPay)
        ? (controller.sender!.showNonKycDetail == true)
            ? Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  "non-kyc",
                  style: TextStyle(color: Colors.red.shade400),
                ))
            : const SizedBox()
        : const SizedBox();
  }

  Text _buildLimitTitleWidget() {
    return Text(
      (controller.dmtType == DmtType.instantPay)
          ? "Available Limit"
          : "Per Limit",
      style: Get.textTheme.subtitle1?.copyWith(color: Colors.white70),
    );
  }

  Widget _buildViewLimitContainer() {
    return GestureDetector(
      onTap: () => controller.showAvailableTransferLimit(),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "View Limit",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeWidget() {
    var style =
        TextStyle(fontWeight: FontWeight.w500, color: HexColor("2ebf14"));
    return Wrap(
      children: [
        _buildIconTitleButton(
            title: "Name", onClick: controller.onNameChange),
        const SizedBox(
          width: 16,
        ),
        _buildIconTitleButton(
            title: "Mobile", onClick: controller.onMobileChange),
      ],
    );
  }

  GestureDetector _buildIconTitleButton(
      {required VoidCallback onClick,
      required String title,
      IconData icon = Icons.edit}) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "[ ",
            style: TextStyle(color: Colors.green),
          ),
          Icon(
            icon,
            color: Colors.green,
            size: 17,
          ),
          Text(
            "$title ]",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildName(String senderName) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        senderName,
        style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
      ),
    );
  }


}
