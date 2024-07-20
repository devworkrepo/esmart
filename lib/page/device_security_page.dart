import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/service/app_lifecycle.dart';
import 'package:esmartbazaar/service/local_auth.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/button.dart';

class DeviceLockPage extends StatelessWidget {
  const DeviceLockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppLifecycleManager(
        onResume: () {
          AppUtil.logger("onResume : ");
          _checkAndNavigateToLoginScreen();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.phonelink_lock,
                          size: 100,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Device doesn't have any security lock",
                          style: Get.textTheme.headline2
                              ?.copyWith(color: Get.theme.primaryColorDark),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Smart Bazaar wants to make user login as simple as possible with high security. Don't need to login app with otp everytime so screen lock is required without it you will not able to access app features. ",
                          style: Get.textTheme.subtitle2?.copyWith(
                              color: Colors.grey[700],
                              wordSpacing: 1.5,
                              height: 1.4),
                        )
                      ],
                    ),
                  )),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                          text: "Go to Setting",
                          onClick: () {
                            _openSecuritySetting();
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(
                        text: "Exit",
                        onClick: () {
                          SystemNavigator.pop();
                        },
                        background: Colors.red,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _openSecuritySetting() async {
    await AppSettings.openSecuritySettings();
  }

  _checkAndNavigateToLoginScreen() async {
    var isAvailable = await LocalAuthService.isAvailable();
    if (isAvailable) {
      Get.offAllNamed(AppRoute.loginPage);
    }
  }
}
