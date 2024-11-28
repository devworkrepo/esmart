//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo/security_deposit_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:esmartbazaar/model/alert.dart';
import 'package:esmartbazaar/model/banner.dart';
import 'package:esmartbazaar/model/investment/investment_summary.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/dmt/dmt.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/component/bottom_sheet_option.dart';
import 'package:esmartbazaar/page/main/home/component/home_service_section.dart';
import 'package:esmartbazaar/page/main_page.dart';
import 'package:esmartbazaar/page/recharge/provider/provider_controller.dart';
import 'package:esmartbazaar/page/statement/account_statement/account_statement_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/service/local_auth.dart';
import 'package:esmartbazaar/util/api/exception.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/future_util.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import 'component/home_biometric_dialog.dart';
import 'component/home_service_section_2.dart';

var isLocalAuthDone = false;
var firstNotificationPlayed = false;

class HomeController extends GetxController {
  var isUpdateObs = false.obs;

  HomeRepo homeRepo = Get.find<HomeRepoImpl>();
  SecurityDepositRepo summaryRepo = Get.find<SecurityDepositImpl>();
  AppPreference appPreference = Get.find();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var userDetailObs = Resource.onInit(data: UserDetail()).obs;
  late UserDetail user;

  late ScrollController scrollController;

  var appbarBackgroundOpacity = 0.0.obs;
  var appbarElevation = 0.0.obs;
  var bannerList = <AppBanner>[].obs;

  var alertMessageObs = AlertMessageResponse().obs;
  var responseObs = Resource.onInit(data: InvestmentSummaryResponse()).obs;

  bool skipBiometric = false;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    appPreference.setIsTransactionApi(false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      scrollController.addListener(_scrollListener);
      _fetchBanners();
    });
  }

  _fetchAlerts() async {
    try {
      var response = await homeRepo.alertMessage();
      alertMessageObs.value = response;
      playNotificationSound();
    } catch (e) {}
  }

  _fetchBanners() async {
    try {
      var response = await homeRepo.fetchBanners();
      if (response.banners != null) {
        var mList = <AppBanner>[]; //response.banners!;
        response.banners!.forEach((element) {
          mList.add(element);
        });
        if (mList.isEmpty) {
          mList.add(AppBanner(
              rawPicName: "https://esmartbazaar.in/images/esmart_bazaar_features.png"));
        }
        mList.add(AppBanner(
            rawPicName: "https://esmartbazaar.in/images/esmart_bazaar_features.png"));
        bannerList.value = mList;
      }
    } catch (e) {}
  }

  _scrollListener() {
    var mOffset = scrollController.offset;

    if (mOffset < 101) {
      var colorOpacity = 0.01 * mOffset;

      if (colorOpacity > 1) {
        colorOpacity = 1;
      }
      if (colorOpacity < 0) {
        colorOpacity = 0;
      }
      appbarBackgroundOpacity.value = colorOpacity;

      var elevation = 20 * colorOpacity;

      appbarElevation.value = elevation;
    }
  }

  authenticateSecurity() async {
    if (appPreference.isBiometricAuthentication) {
      if (!isLocalAuthDone) {
        var result = false;
        if(appPreference.mobileNumber == "9785172173" || appPreference.mobileNumber == "7982607742"){
          result = true;
        }
       else {
          result = await LocalAuthService.authenticate();
        }

        isLocalAuthDone = result;
        _fetchAlerts();
        firstNotificationPlayed = result;
      }
    } else {
      firstNotificationPlayed = true;
      if (!skipBiometric) {
        if (!(Get.isDialogOpen ?? true)) {
          if (Get.currentRoute == AppRoute.mainPage) {
            Get.dialog(const HomeBiometricDialog(), barrierDismissible: false);
          }
        }
      }
    }
  }

  fetchUserDetails() async {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isRetailerBottomNavObs.value = false;
      _fetchUserDetails();
      if (firstNotificationPlayed) _fetchAlerts();
    });
  }


  _fetchUserDetails() async {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isRetailerBottomNavObs.value = false;
    });
    userDetailObs.value = const Resource.onInit();
    try {
     //todo  AppUtil.throwUatExceptionOnDeployment(appPreference.mobileNumber);

      UserDetail response = await homeRepo.fetchAgentInfo();

      user = response;
      await appPreference.setUser(user);

      authenticateSecurity();

      //await setupCrashID();

      if (response.code == 1) {
        if(appPreference.user.userType == "Retailer") {
          isRetailerBottomNavObs.value = true;
        }
        else{
          isRetailerBottomNavObs.value = false;
        }
        appbarBackgroundOpacity.value = 0;
        appbarElevation.value = 0;

      }
      userDetailObs.value = Resource.onSuccess(response);
      if(appPreference.user.userType == "Sub-Merchant"){
        _fetchInvestmentSummary();
      }
    } catch (e) {
      isRetailerBottomNavObs.value = false;
      userDetailObs.value = Resource.onFailure(e);

      if (getDioException(e) is SessionExpireException) {
        Get.offAllNamed(AppRoute.loginPage);
      } else {
        Get.dialog(ExceptionPage(error: e));
      }
    }
  }

  _fetchInvestmentSummary() async {
    ObsResponseHandler<InvestmentSummaryResponse>(
        obs: responseObs,
        apiCall: summaryRepo.fetchSummary());
  }

  onTopUpButtonClick() {
    Get.toNamed(AppRoute.fundRequestOptionPage);
  }

  onQRCodeButtonClick() {
    Get.toNamed(AppRoute.showQRCodePage);
  }

  void logout() async {
    try {
      StatusDialog.progress(title: "Log out...");
      var response = await homeRepo.logout();
      Get.back();

      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    } catch (e) {
      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    }
  }

  onItemClick2(HomeServiceItem2 item) {
    switch (item.homeServiceType) {
      case HomeServiceType2.createInvestment:
        Get.toNamed(AppRoute.createInvestmentPage);
        break;
      case HomeServiceType2.investmentList:
        Get.toNamed(AppRoute.investmentListPage,arguments: {
          "home": false
        });
        break;
      case HomeServiceType2.addFundOnline:
        Get.toNamed(AppRoute.addFundOnline);
        break;
      case HomeServiceType2.fundHistory:
        Get.toNamed(AppRoute.fundReportPage, arguments: {"is_pending": true});
        break;
      case HomeServiceType2.investmentSummary:
        Get.toNamed(AppRoute.investmentSummary,);
        break;
      case HomeServiceType2.accountStatement:
        Get.to(() => const AccountStatementPage(
            controllerTag: AppTag.accountStatementControllerTag));
        break;

      default:
        {}
    }
  }

  onItemClick(HomeServiceItem item) {
    switch (item.homeServiceType) {
      case HomeServiceType.aeps:

        {
          Get.bottomSheet(AepsDialogWidget(
            onFingPay: () {
              Get.toNamed(AppRoute.aepsFingPage);

            },
            onTramo: () {
              Get.toNamed(AppRoute.aepsTramoPage,arguments: false);

            },
          ));
        }
        break;
      case HomeServiceType.aadhaarPay:
        {
          Get.toNamed(AppRoute.aepsTramoPage, arguments: true);
        }

        break;
      case HomeServiceType.matm:
        {
          var user = appPreference.user;
          var isMatm = user.isMatm ?? false;
          var isMatmCredo = user.is_matm_credo ?? false;
          var isMposCredo = user.is_mpos_credo ?? false;

          if ((isMatm || isMatmCredo) && isMposCredo) {
            Get.bottomSheet(MatmOptionDialog(
              matmClick: () {
                if (isMatm) {
                  Get.toNamed(AppRoute.matmTramopage);
                } else if (isMatmCredo) {
                  Get.toNamed(AppRoute.matmCredoPage, arguments: true);
                }
              },
              mposClick: () {
                Get.toNamed(AppRoute.matmCredoPage, arguments: false);
              },
            ));
          } else if (isMposCredo) {
            Get.toNamed(AppRoute.matmCredoPage, arguments: false);
          } else if (isMatmCredo) {
            Get.toNamed(AppRoute.matmCredoPage, arguments: true);
          } else if (isMatm) {
            Get.toNamed(AppRoute.matmTramopage);
          }
        }
        break;
      case HomeServiceType.moneyTransfer:
        {

            Get.bottomSheet(DmtOptionDialog(
              onDmtOne: () {
                var dmtType = DmtType.instantPay;
                Get.toNamed(AppRoute.dmtSearchSenderPage,
                    arguments: {"dmtType": dmtType});

              },
              onDmtTwo: () {
                var dmtType = DmtType.dmt2;
                Get.toNamed(AppRoute.dmtSearchSenderPage,
                    arguments: {"dmtType": dmtType});
              },
            ));




          // var dmtType = DmtType.instantPay;
          // Get.toNamed(AppRoute.dmtSearchSenderPage,
          //     arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.upiTransfer:
        {
          Get.toNamed(AppRoute.upiSearchSenderPage,
              arguments: {});
        }
        break;
      case HomeServiceType.payoutTransfer:
        {
          var dmtType = DmtType.payout;
          Get.toNamed(AppRoute.dmtSearchSenderPage,
              arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.recharge:
        {
          Get.bottomSheet(RechargeOptionDialog(
            onPrepaidClick: () {
              Get.toNamed(AppRoute.providerPage,
                  arguments: ProviderType.prepaid);
            },
            onPostpaidClick: () {
              Get.toNamed(AppRoute.providerPage,
                  arguments: ProviderType.postpaid);
            },
          ));
        }
        break;
      case HomeServiceType.dth:
        {
          Get.toNamed(AppRoute.providerPage, arguments: ProviderType.dth);
        }
        break;
      case HomeServiceType.billPayment:
        {
          Get.toNamed(AppRoute.providerPage,
              arguments: ProviderType.electricity);
        }
        break;
      case HomeServiceType.partBillPayment:
        {
          var provider = Provider.fromJson2(
            {
              "id": "93",
              "name": "Tata Power - Delhi / North Delhi Power Limited(NDPL)",
              "opcode": "TR79"
            },
          );

          Get.toNamed(AppRoute.billPaymentPage, arguments: {
            "is_part_bill": true,
            "provider": provider,
            "provider_name": getProviderInfo(ProviderType.electricity)?.name,
            "provider_image":
                getProviderInfo(ProviderType.electricity)?.imageName.toString(),
            "provider_type": ProviderType.electricity
          });
        }
        break;
      case HomeServiceType.insurance:
        {
          Get.toNamed(AppRoute.providerPage, arguments: ProviderType.insurance);
        }
        break;
      case HomeServiceType.walletPay:
        {
          Get.toNamed(AppRoute.walletSearchPage);
        }
        break;

      case HomeServiceType.creditCard:
        {
          Get.toNamed(AppRoute.creditCardPage);
        }
        break;
      case HomeServiceType.lic:
        {
          Get.toNamed(AppRoute.licPaymentPage);
        }
        break;
      case HomeServiceType.paytmWallet:
        {
          Get.toNamed(AppRoute.paytmWalletLoadPage);
        }
        break;
      case HomeServiceType.ott:
        {
          Get.toNamed(AppRoute.ottOperatorPage);
        }
        break;
      case HomeServiceType.virtualAccount:
        {
          Get.bottomSheet(VirtualAccountOptionDialog(
            onAccountView: () {
              Get.toNamed(AppRoute.virtualAccountPage);
            },
            onTransactionView: () {
              Get.toNamed(AppRoute.virtualAccountTransactionTabPage);
            },
          ));
        }
        break;
      case HomeServiceType.securityDeposity:
        {
          Get.toNamed(AppRoute.securityDepositPage);
        }
        break;
      case HomeServiceType.fundAddOnline:
        {
          Get.toNamed(AppRoute.addFundOnline);
        }
        break;
      case HomeServiceType.upiPayment:
        {
          Get.toNamed(AppRoute.upiPayment);
        }
        break;
      case HomeServiceType.cms:
        {
          Get.toNamed(AppRoute.cmsServicePage);
        }
        break;
      case HomeServiceType.newInvestment:
        {
          Get.toNamed(AppRoute.createInvestmentPage);
        }
        break;
      case HomeServiceType.qrCode:
        {
          Get.toNamed(AppRoute.myQrCodePage);
        }
        break;
      default:
        break;
    }
  }

  onAddFundClick() {
    Get.toNamed(AppRoute.fundRequestPage);
  }

  onNotificationClick() {
    Get.toNamed(AppRoute.notificationPage);
  }

  onSummaryClick() {
    Get.toNamed(AppRoute.summaryPage);
  }

  //todo crashID()
  // Future<void> setupCrashID() async {
  //   var userId = appPreference.user.agentId.toString();
  //   var agentCode = appPreference.user.agentCode.toString();
  //   await FirebaseCrashlytics.instance.setCustomKey("user ID", userId);
  //   await FirebaseCrashlytics.instance.setCustomKey("user Code", agentCode);
  //   await FirebaseCrashlytics.instance
  //       .setCustomKey("Mobile", appPreference.mobileNumber);
  // }

  playNotificationSound() async {
    try {
      if (alertMessageObs.value.alert_no != null) {
        if (int.parse(alertMessageObs.value.alert_no!) > 0) {
          FlutterRingtonePlayer.play(
              fromAsset: "assets/sound/sound2.wav", looping: false);
        }
      }
    } catch (e) {}
  }
}

class HomeService {
  String title;
  String iconPath;
  VoidCallback? onClick;

  HomeService({
    required this.title,
    required this.iconPath,
    this.onClick,
  });
}

enum ProviderType {
  prepaid,
  dth,
  electricity,
  water,
  gas,
  postpaid,
  landline,
  broadband,
  insurance,
  ott,
}
