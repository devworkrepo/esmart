import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/virtual_account/virtual_account.dart';
import 'package:esmartbazaar/page/virtual_account/account/virtual_account_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';

class VirtualAccountPage extends GetView<VirtualAccountController> {
  const VirtualAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VirtualAccountController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Account"),
      ),
      body: ObsResourceWidget<VirtualAccountDetailResponse>(
          obs: controller.responseObs,
          childBuilder: (data) {
            if (data.code == 1) {

              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: data.virtualAccountList!.length,
                    itemBuilder: (context,index)=> _BuildListItem(data.virtualAccountList![index]),)
              );;
            } else {
              return NoItemFoundWidget(
                icon: Icons.info,
                message: data.message,
              );
            }
          }),
    );
  }
}







class _BuildListItem extends StatelessWidget {
  final VirtualAccount account;

  const _BuildListItem(this.account, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        color: Get.theme.primaryColorDark,
        child: buildCommonDetailWidget(
            account.bank_name!, account.account_no!, account.ifsc!),
      ),
    );
  }


  buildCommonDetailWidget(
      String bankName, String accountNumber, String ifscCode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "A/C No :"+ accountNumber,
            style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Bank  : " + bankName,
            style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Ifsc    : " + ifscCode,
            style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
