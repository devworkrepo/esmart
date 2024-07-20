import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt_upi/beneficiary/list/beneficiary_controller.dart';


class UpiBeneficiarySenderHeader extends GetView<UpiBeneficiaryListController> {
  final VoidCallback onClick;
  final String mobileNumber;
  final String senderName;
  final String limit;

  const UpiBeneficiarySenderHeader({Key? key,
    required this.onClick,
    required this.mobileNumber,
    required this.senderName,
    required this.limit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
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
                  const SizedBox(height: 3,),
                  _buildName(mobileNumber),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLimitTitleWidget(),

                Obx(() =>
                controller.showAvailableTransferLimitObs.value == true
                    ? _buildLimitBalanceWidget()
                    : _buildViewLimitContainer()),

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
    return Text(
      "₹ ${ controller.sender?.upi_limit }",
      style: Get.textTheme.headline3?.copyWith(color: Colors.green),
    );
  }

  SingleChildRenderObjectWidget _buildNonKycWidget() {
    return const SizedBox();
  }

  Text _buildLimitTitleWidget() {
    return Text(
      "Available Limit",

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
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
