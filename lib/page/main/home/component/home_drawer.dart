import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/aeps_settlement/settlement/settlement_controller.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/statement/account_statement/account_statement_page.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/tags.dart';
import 'package:esmartbazaar/widget/common/common_confirm_dialog.dart';

import '../../../../widget/image.dart';
import '../../../biometric_setting_page.dart';

class HomeDrawerWidget extends GetView<HomeController> {
  const HomeDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.white;
    return Drawer(
      elevation: 16,
      child: Material(

        child: SafeArea(
          child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColorDark.withOpacity(0.3),
                Get.theme.primaryColorDark.withOpacity(0.8)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),

            margin: const EdgeInsets.all(4),
            child: ListView(

              children: [
                _buildUserInfo(),
                Card(
                  color: Get.theme.primaryColorDark,
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      controller.fetchUserDetails();
                    },
                    title: Text(
                      "Home",
                      style: Get.textTheme.subtitle1
                          ?.copyWith(color: color, fontWeight: FontWeight.bold,
                      fontSize: 14),
                    ),
                    leading: Icon(
                      Icons.home,
                      color: color,
                    ),
                  ),
                ),


                if (controller.appPreference.user.userType == "Sub-Merchant")
                  Card(

                    child: _NavTitle(
                      title: "Investments",
                      icon: Icons.inventory_sharp,
                      children: [
                        _NavSubTitle(
                          title: "Create Investment",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.createInvestmentPage);
                          },
                          underline: false,
                          count: 1,
                        ),
                        _NavSubTitle(
                          title: "Investment List",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.investmentListPage,arguments:{"home" : false});
                          },
                          underline: false,
                          count: 2,
                        ),
                      ],
                    ),
                  ),
                if (controller.appPreference.user.userType == "Sub-Merchant")
                  Card(
                    child: _NavTitle(
                      title: "Transactions",
                      icon: Icons.receipt_outlined,
                      children: [
                        _NavSubTitle(
                          title: "Investment Withdrawal",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.investmentWithdrawnPage);
                          },
                          underline: false,
                          count: 1,
                        ),
                        _NavSubTitle(
                          title: "Fund Transaction",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.fundReportPage,arguments: {"is_pending": false});
                          },
                          underline: false,
                          count: 2,
                        ),
                      ],
                    ),
                  ),

                if (controller.appPreference.user.userType == "Sub-Merchant") Card(
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoute.investmentBankListPage,arguments: {
                        "origin" : true
                      });
                    },
                    title: Text(
                      "Settlement Accounts",
                      style: Get.textTheme.subtitle1
                          ?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                    leading: Icon(
                      Icons.account_balance,
                      color: color,
                    ),
                  ),
                ),


                if (controller.appPreference.user.userType == "Sub-Merchant")
                  Card(
                    child: _NavTitle(
                      title: "Statements",
                      icon: Icons.receipt_long_sharp,
                      children: [
                        _NavSubTitle(
                          title: "Account Statement",
                          onClick: () {
                            Get.back();
                            Get.to(()=>const AccountStatementPage(controllerTag: AppTag.accountStatementControllerTag));
                          },
                          underline: false,
                          count: 1,
                        ),
                        _NavSubTitle(
                          title: "Wallet Receipt List",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.walletReportPage);
                          },
                          underline: false,
                          count: 2,
                        ),
                      ],
                    ),
                  ),

                if (controller.appPreference.user.userType == "Retailer")
                  Card(
                    color: Get.theme.primaryColorDark,
                    child: _NavTitle(
                      title: "Reports",
                      icon: Icons.receipt_outlined,
                      children: [
                        _NavSubTitle(
                          title: "Transaction",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.transactionReportPage);
                          },
                          count: 1,
                        ),
                        _NavSubTitle(
                          title: "Statement",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.statementReportPage);
                          },
                          count: 2,
                        ),
                        _NavSubTitle(
                          title: "Refund Pending",
                          onClick: () {
                            Get.back();
                            Get.toNamed(AppRoute.refundReportPage);
                          },
                          count: 3,
                        ),
                        _NavSubTitle(
                          title: "Smart Pay",
                          onClick: () => Get.toNamed(AppRoute.walletReportPage),
                          count: 4,
                        ),
                        if (controller.appPreference.user.isVirtualAccount ??
                            false)
                          _NavSubTitle(
                            title: "Virtual Account",
                            onClick: () => Get.toNamed(
                                AppRoute.virtualAccountTransactionTabPage),
                            count: 5,
                          ),
                        if (controller.appPreference.user.isSecurityDeposit ??
                            false)
                          _NavSubTitle(
                            title: "Security Deposit",
                            onClick: () =>
                                Get.toNamed(AppRoute.securityDepositReportPage),
                            count: (controller
                                        .appPreference.user.isVirtualAccount ??
                                    false)
                                ? 6
                                : 5,
                          ),
                      ],
                    ),
                  ),
               if(controller.appPreference.user.userType == "Retailer")
                 Card(
                   color: Get.theme.primaryColorDark,
                  child: _NavTitle(
                    title: "Fund Request",
                    icon: Icons.money,
                    children: [
                      _NavSubTitle(
                        title: "New Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundRequestPage);
                        },
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "InComplete Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundReportPage,
                              arguments: {"is_pending": true});
                        },
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "All Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundReportPage,
                              arguments: {"is_pending": false});
                        },
                        count: 3,
                      ),
                    ],
                  ),
                ),
                if (controller.appPreference.user.userType == "Retailer")
                  Card(
                    color: Get.theme.primaryColorDark,
                  child: _NavTitle(
                    title: "AePS Settlement",
                    icon: Icons.fingerprint,
                    children: [
                      /* _NavSubTitle(
                        title: "OnBoarding",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsOnboardingPage);
                        },
                        count: 1,
                      ),

                      _NavSubTitle(
                        title: "E-Kyc",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsEkycPage);
                        },
                        underline: false,
                        count: 2,
                      ),*/
                      _NavSubTitle(
                        title: "To Smart Wallet",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsSettlementPage, arguments: {
                            "aeps_settlement_type":
                                AepsSettlementType.spayAccount
                          });
                        },
                        underline: false,
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "To Bank Account",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsSelectSettlementBank);
                        },
                        underline: false,
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "Account Status",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsSettlemenBankListtPage);
                        },
                        underline: false,
                        count: 3,
                      )
                    ],
                  ),
                ),
                if (controller.appPreference.user.userType == "Retailer")
                  if ( controller.user.isSecurityDeposit ?? false)  Card(
                    color: Get.theme.primaryColorDark,
                  child: _NavTitle(
                    title: "Investments",
                    icon: Icons.inventory_sharp,
                    children: [
                      _NavSubTitle(
                        title: "Create Investment",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.createInvestmentPage);
                        },
                        underline: false,
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "Investment List",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.investmentListPage,arguments:{"home" : false});
                        },
                        underline: false,
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "Investment Withdrawal",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.investmentWithdrawnPage);
                        },
                        underline: false,
                        count: 3,
                      ),
                      _NavSubTitle(
                        title: "Investment Summary",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.investmentSummary);
                        },
                        underline: false,
                        count: 4,
                      )
                    ],
                  ),
                ),
                Card(
                  color: Get.theme.primaryColorDark,
                  child: _NavTitle(
                    title: "Settings",
                    icon: Icons.settings_rounded,
                    children: [
                      _NavSubTitle(
                        title: "Login Sessions",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.manageLoginSession);
                        },
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "Change Password",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.changePassword);
                        },
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "Change Pin",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.changePin);
                        },
                        underline: false,
                        count: 3,
                      ),
                      _NavSubTitle(
                        title: "Biometric Login",
                        onClick: () {
                          Get.back();
                          Get.to(() => const BiometricSettingPage());
                        },
                        underline: false,
                        count: 4,
                      ),
                      _NavSubTitle(
                        title: "Onboarding",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsOnboardingPage);
                        },
                        underline: false,
                        count: 4,
                      ),
                    ],
                  ),
                ),
                // if (controller.appPreference.user.userType == "Retailer")
                //   Card(
                //   child: ListTile(
                //     onTap: () {
                //       Get.back();
                //       Get.toNamed(AppRoute.complaintPage);
                //     },
                //     title: Text(
                //       "Complaints",
                //       style: Get.textTheme.subtitle1
                //           ?.copyWith(color: color, fontWeight: FontWeight.bold,
                //       fontSize: 14),
                //     ),
                //     leading: Icon(
                //       Icons.messenger_outline,
                //       color: color,
                //     ),
                //   ),
                // ),
                Card(
                  color: Get.theme.primaryColorDark,
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      Get.dialog(CommonConfirmDialogWidget(
                        title: "Logout",
                       description :  "Are you sure! to logout from the app. It will clear login session",
                        onConfirm: () {
                          controller.logout();
                        },
                      ));
                    },
                    title: Text(
                      "Logout",
                      style: Get.textTheme.subtitle1
                          ?.copyWith(color: color, fontWeight: FontWeight.bold,
                      fontSize: 14),
                    ),
                    leading: Icon(
                      Icons.power_settings_new,
                      color: color,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "App Version :N/A",
                      style: Get.textTheme.subtitle2?.copyWith(
                        color: Colors.grey[500],
                        fontSize: 12
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildUserInfo() {
    return Card(
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  image: AssetImage("assets/icon/background2.jpg",),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.purple, BlendMode.modulate)
              )
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     Get.theme.primaryColorDark,
            //     Get.theme.primaryColor,
            //     Get.theme.colorScheme.secondary,
            //
            //   ]
            // )
          ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCircleNetworkImage(
              AppConstant.profileBaseUrl + controller.user.picName.toString(),
              size: 70,
            ),
            const SizedBox(height: 8),
            Text(
              "Welcome",
              style: Get.textTheme.subtitle1?.copyWith(color: Colors.white,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "${controller.appPreference.user.fullName} - ${controller.appPreference.user.userType}",
              style: Get.textTheme.bodyText2?.copyWith(color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              controller.appPreference.mobileNumber,
              style: Get.textTheme.bodySmall?.copyWith(color: Colors.white70,
              fontSize: 12,fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_NavSubTitle> children;

  const _NavTitle(
      {Key? key,
      required this.title,
      required this.children,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        expandedAlignment: Alignment.centerLeft,
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white70,
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        childrenPadding: const EdgeInsets.only(left: 0, right: 8, bottom: 16),
        title: Text(
          title,
          style: Get.textTheme.subtitle1?.copyWith(
            fontSize: 14,
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        children: children,
      ),
    );
  }
}

class _NavSubTitle extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool underline;
  final int count;

  const _NavSubTitle(
      {Key? key,
      required this.title,
      required this.onClick,
      this.underline = true,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.back();
        onClick();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 8, top: 12, bottom: 12),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: Center(
                      child: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColorLight,
                      borderRadius: BorderRadius.circular(30)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title,
                    style: Get.textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white70  ,
                        fontSize: 14  ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
