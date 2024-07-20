import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_aitel_impl.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_fing_impl.dart';
import 'package:esmartbazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/auth_impl.dart';
import 'package:esmartbazaar/data/repo_impl/complain_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/matm_credo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/money_request_impl.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/report_impl.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/data/repo_impl/virtual_account_impl.dart';
import 'package:esmartbazaar/data/repo_impl/wallet_repo_impl.dart';
import 'package:esmartbazaar/page/matm_credo/matm_credo_page.dart';
import 'package:esmartbazaar/service/network_client.dart';
import 'package:esmartbazaar/service/network_sign_up_client.dart';
import 'package:esmartbazaar/service/provide_async.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repo_impl/singup_impl.dart';
import '../data/repo_impl/upi_repo_impl.dart';

appBinding() async {
  //async binding
  SharedPreferences preferences = await provideSharePreference();
  Get.put(preferences, permanent: true);
  Get.put(AppPreference(Get.find()));



/*  try{
    var newVersion =  NewVersion(androidId: 'app.esmartbazaar.com',);
    VersionStatus? versionStatus = await newVersion.getVersionStatus();
    Get.put(versionStatus,permanent: true);
  }catch(e){

  }*/


  //network client binding
  Get.lazyPut(() => Connectivity(), fenix: true);
  Get.lazyPut(() => NetworkClient(Get.find(), Get.find()), fenix: true);
  Get.lazyPut(() => NetworkSignUpClient(Get.find(), Get.find()), fenix: true);

  //repo binding
  Get.lazyPut(() => AuthRepoImpl(), fenix: true);
  Get.lazyPut(() => SingUpRepoImpl(), fenix: true);
  Get.lazyPut(() => RechargeRepoImpl(), fenix: true);
  Get.lazyPut(() => HomeRepoImpl(), fenix: true);
  Get.lazyPut(() => DmtRepoImpl(), fenix: true);
  Get.lazyPut(() => AepsRepoImpl(), fenix: true);
  Get.lazyPut(() => AepsFingRepoImpl(), fenix: true);
  Get.lazyPut(() => AepsAirtelRepoImpl(), fenix: true);
  Get.lazyPut(() => ReportRepoImpl(), fenix: true);
  Get.lazyPut(() => WalletRepoImpl(), fenix: true);
  Get.lazyPut(() => MoneyRequestImpl(), fenix: true);
  Get.lazyPut(() => VirtualAccountImpl(), fenix: true);
  Get.lazyPut(() => SecurityDepositImpl(), fenix: true);
  Get.lazyPut(() => MatmCredoImpl(), fenix: true);
  Get.lazyPut(() => ComplainRepoImpl(), fenix: true);
  Get.lazyPut(() => UpiRepoImpl(), fenix: true);

}
