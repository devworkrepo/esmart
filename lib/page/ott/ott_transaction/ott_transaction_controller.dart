import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common/confirm_amount_dialog.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/recharge_repo.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/model/ott/ott_operator.dart';
import 'package:esmartbazaar/model/ott/ott_plan.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/response/recharge/recharge_txn_response_page.dart';

import '../../../util/mixin/location_helper_mixin.dart';
import '../../../util/security/encription.dart';
import '../../../widget/common.dart';
import '../../../widget/dialog/status_dialog.dart';
import '../../exception_page.dart';

class OttTransactionController extends GetxController with LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  AppPreference appPreference = Get.find();

  OttOperator operator = Get.arguments["operator"];
  OttPlan plan = Get.arguments["ott_plan"];
  var mobileController = TextEditingController();
  var emailController = TextEditingController();
  var mpinController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
    });
  }

  onProceed() async{
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (position == null) {
      await validateLocation();
      return;
    }
    Get.dialog(AmountConfirmDialogWidget(
      amount: plan.amount.toString(),
      onConfirm: () {
        _ottTransaction();
      },
    ));
  }

  Future<String?> fetchTransactionNumber() async {
    try {
      StatusDialog.progress();
      var response = await repo.fetchTransactionNumber();
      Get.back();
      if (response.code == 1) {
        return response.transactionNumber;
      } else {
        showFailureSnackbar(
            title: "Something went wrong", message: response.message);
        return null;
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
      return null;
    }
  }

  _ottTransaction() async {
    try {

      String? transactionNumber = await fetchTransactionNumber();
      if (transactionNumber == null) {
        StatusDialog.failure(title: "Transaction Number is Required");
        return;
      }

      StatusDialog.transaction();
      var response = await repo.ottTransaction({
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "transaction_no": transactionNumber,
        "mobileno": mobileController.text,
        "emailid": emailController.text,
        "amount": plan.amount.toString(),
        "planid": plan.id.toString(),
        "operatorcode": operator.operatorCode.toString(),
        "operatorname": operator.operatorName.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      });
      Get.back();
      if (response.code == 1) {
        Get.to(() => RechargeTxnResponsePage(),
            arguments: {"response": response, "type": ProviderType.ott});
      } else {
        StatusDialog.failure(title: response.message );
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    mpinController.dispose();
    super.dispose();
  }
}
