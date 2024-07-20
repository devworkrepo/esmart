import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/widget/button.dart';

import '../../../biometric_setting_page.dart';

class HomeBiometricDialog extends GetView<HomeController> {
  const HomeBiometricDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/image/biometric.png",
                height: 120,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Enable Biometric ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "To secure login, please enable biometric authentication from app setting.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),
                  onPressed: () {
                    Get.back();
                    Get.to(() => const BiometricSettingPage());
                  },
                  child: const Text("        Enable        ")),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                    onPressed: () {
                      Get.back();
                      controller.skipBiometric = true;
                    },
                    child: const Text(
                      "Skip for now",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
