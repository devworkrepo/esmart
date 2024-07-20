import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/page/main/home/home_page.dart';
import 'package:esmartbazaar/page/profile/profile_page.dart';
import 'package:esmartbazaar/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:esmartbazaar/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:esmartbazaar/page/refund/refund_tab.dart';
import 'package:esmartbazaar/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:esmartbazaar/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:esmartbazaar/page/report/money_report/money_report_controller.dart';
import 'package:esmartbazaar/page/report/recharge_report/recharge_report_controller.dart';
import 'package:esmartbazaar/page/report/transaction_tab.dart';
import 'package:esmartbazaar/page/statement/account_statement/account_statement_controller.dart';
import 'package:esmartbazaar/page/statement/credit_debit/credit_debit_controller.dart';
import 'package:esmartbazaar/page/statement/statement_tab.dart';
import 'package:esmartbazaar/res/style.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/service/local_auth.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/status_bar_color_widget.dart';

import '../service/native_call.dart';
import '../widget/dialog/status_dialog.dart';
import 'main/home/home_controller.dart';

var isRetailerBottomNavObs = true.obs;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var bottomNavStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Get.theme.primaryColorDark);
  var backgroundColor = Colors.lightBlue[100];
  var bottomNavSelectedIndex = 2;
  var selectedItemColor = Get.theme.primaryColorDark;
  var bottomNavKey = GlobalKey();

  late AppPreference appPreference;


  HomeRepo rep = Get.find<HomeRepoImpl>();

  @override
  void initState() {
    super.initState();
    appPreference = Get.find();
    setTransactionApi();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (bottomNavSelectedIndex == 2) {
          showExitDialog();
          return false;
        } else {
          setState(() {
            var nav = bottomNavKey.currentWidget as BottomNavigationBar?;
            nav?.onTap!(2);
          });
          return false;
        }
      },
      child: StatusBarColorWidget(
        child: Scaffold(

          bottomNavigationBar: _buildBottomNavigationBar() ,
          body: _bottomNavPage(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Visibility(
          visible: isRetailerBottomNavObs.value,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shadowColor: Colors.blue,
            elevation: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 1,
                  width: Get.width,
                  color: Colors.grey[300],
                ),
                BottomNavigationBar(
                  backgroundColor: Colors.white,
                  key: bottomNavKey,
                  elevation: 20,

                  selectedLabelStyle: bottomNavStyle,
                  unselectedLabelStyle: bottomNavStyle,
                  selectedItemColor: selectedItemColor,
                  unselectedItemColor: Colors.black45,
                  // backgroundColor: Get.theme.primaryColor,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: bottomNavSelectedIndex,
                  onTap: _onBottomNavItemClick,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.keyboard_return), label: "Refund"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_long_rounded),
                        label: "Statement"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_outlined),
                        label: "Transaction"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Profile"),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _onBottomNavItemClick(position) {
    if (position != bottomNavSelectedIndex) {
      setState(() {
        selectedItemColor = Get.theme.primaryColorDark;
        bottomNavSelectedIndex = position;
      });
    }
  }

  _bottomNavPage() {
    AppUtil.logger("test bottom bar tap click");

    switch (bottomNavSelectedIndex) {
      case 0:
        Get.delete<DmtRefundController>(tag: AppTag.payoutRefundControllerTag);
        Get.delete<DmtRefundController>(tag: AppTag.moneyRefundControllerTag);
        Get.delete<RechargeRefundController>();
        Get.delete<CreditCardRefundController>();
        return const RefundTabPage();
      case 1:
        Get.delete<AccountStatementController>(
            tag: AppTag.accountStatementControllerTag);
        Get.delete<AccountStatementController>(
            tag: AppTag.aepsStatementControllerTag);
        Get.delete<CreditDebitController>(
            tag: AppTag.creditStatementControllerTag);
        Get.delete<CreditDebitController>(
            tag: AppTag.debitStatementControllerTag);
        return const StatementTabPage();
      case 2:
        return HomePage(
          userInfo: (info) {},
        );
      case 3:
        Get.delete<MoneyReportController>(tag: AppTag.payoutReportControllerTag);
        Get.delete<MoneyReportController>(tag: AppTag.moneyReportControllerTag);
        Get.delete<RechargeReportController>();
        Get.delete<AepsMatmReportController>(tag: AppTag.aepsReportControllerTag);
        Get.delete<AepsMatmReportController>(tag: AppTag.aadhaarPayReportControllerTag);
        Get.delete<AepsMatmReportController>(tag: AppTag.matmReportControllerTag);
        Get.delete<AepsMatmReportController>(tag: AppTag.mposReportControllerTag);
        Get.delete<CreditCardReportController>();
        return const TransactionTabPage();
      case 4:
        return const ProfilePage();
      default:
        return Center(
          child: Text(
            "Work on Progress",
            style: Get.textTheme.headline6,
          ),
        );
    }
  }

  void setTransactionApi() async {
    await appPreference.setIsTransactionApi(false);
  }

  void showExitDialog() async {
    Get.bottomSheet(Container(
      decoration: AppStyle.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (appPreference.isBiometricAuthentication)
                  ? "Exit or Logout ? "
                  : "Logout ? ",
              style: Get.textTheme.headline6
                  ?.copyWith(color: Get.theme.primaryColorDark),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "Logout will clear all login sessions!",
                style: Get.textTheme.bodyText1?.copyWith(
                  color: Colors.grey[700],
                  fontSize: 14
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (appPreference.isBiometricAuthentication)
              Row(
                children: [
                  Expanded(
                      child: AppButton(
                    text: "Logout",
                    onClick: () {
                      Get.back();
                      logout();
                    },
                    background: Colors.red,
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: AppButton(
                      text: "Exit",
                      onClick: () {
                        isLocalAuthDone = false;
                        Get.back();
                        SystemNavigator.pop();
                      },
                      background: Get.theme.primaryColorDark,
                    ),
                  )
                ],
              ),
            if (!appPreference.isBiometricAuthentication)
              AppButton(
                text: "Logout",
                onClick: () {
                  Get.back();
                  logout();
                },
                background: Colors.red,
              )
          ],
        ),
      ),
    ));
  }

  void logout() async {
    try {
      StatusDialog.progress(title: "Log out...");
      var response = await rep.logout();
      Get.back();

      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    } catch (e) {
      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    }
  }
}
