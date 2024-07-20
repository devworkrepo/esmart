import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';
import 'package:esmartbazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:esmartbazaar/widget/common/common_confirm_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../data/repo/home_repo.dart';
import '../../data/repo_impl/home_repo_impl.dart';
import '../../model/profile.dart';
import '../../util/api/resource/resource.dart';
import '../../util/future_util.dart';

class SecurityDepositController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  var formKey = GlobalKey<FormState>();
  var amountController = TextEditingController();
  var aadhaarController = TextEditingController();
  var mpinController = TextEditingController();

  var tenureObs = 1.obs;

  var responseObs = Resource.onInit(data: UserProfile()).obs;
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();
  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  late String firstName;
  late String lastName;
  late String dob;
  late String mobile;
  late String email;
  late String panNumber;

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchUserProfile();
      validateLocation(progress: false);
    });
  }

  _parseNames(String fullName) {
    var names = fullName.toString().trim().split(" ");
    firstName = names.first;
    lastName = names.last;
  }

  _parseDob(String value) {
    var date = DateFormat("dd/MM/yyyy HH:mm:ss").parse(value);
    dob = "${date.day}/${date.month}/${date.year}";
  }

  _fetchUserProfile() async {
    ObsResponseHandler<UserProfile>(
        obs: responseObs,
        apiCall: homeRepo.fetchProfileInfo(),
        result: (value) {
          mobile = value.outlet_mobile.toString();
          email = value.emailid.toString();
          panNumber = value.pan_no.toString();
          _parseNames(value.fullname.toString());
          _parseDob(value.dob.toString());
        });
  }

  onSubmit() async {
    if (!formKey.currentState!.validate()) return;
    if (position == null) {
      await validateLocation();
      return;
    }

    Get.dialog(CommonConfirmDialogWidget(
      onConfirm: () {
        _postDepositFormData();
      },
      description:
          "Are you sure! to deposit ${amountController.text} for tenure ${tenureObs.value.toString()} ${(tenureObs.value == 1) ? "Year" : "Years"}",
    ));
  }

  _postDepositFormData() async {
    try {
      StatusDialog.progress(title: "Processing..");

      var res = await homeRepo.getTransactionNumber();
      var transactionNumber = res.transactionNumber.toString();
      var response = await repo.addDeposit({
        "fname": firstName,
        "lname": lastName,
        "mobileno": mobile,
        "emailid": email,
        "pan_no": panNumber,
        "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
        "tenure": tenureObs.value.toString(),
        "dob": dob,
        "amount": amountWithoutRupeeSymbol(amountController),
        "transaction_no": transactionNumber,
        "mpin": mpinController.text.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.offAllNamed(AppRoute.mainPage));
      } else if (response.code == 2 || response.code == 3) {
        Get.offNamed(AppRoute.securityDepositReportPage);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}
