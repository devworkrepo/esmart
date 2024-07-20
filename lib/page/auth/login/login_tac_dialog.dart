import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/button.dart';

class LoginTermAndConditionDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const LoginTermAndConditionDialog(
      {required this.onAccept, required this.onReject, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 64),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Login Information",style: Get.textTheme.headline4?.copyWith(color: Colors.black),),
                      const SizedBox(height: 8,),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text("User data will be store in strong encryption form. "
                              "Login session will be for 15 days, once you login into app you will be get direct "
                              "access to homepage for 15 days. After 15 days again need to login and verify "
                              "with otp. App access is secure with biometric authentication you can enable "
                              "and disable into smart bazaar app settings. If your device doesn't  support biometric "
                              "authentication you will get direct access to homepage without any login information "
                              "for 15 days. So if you wish login first to access your smart bazaar retailer account just "
                              "logout instead of direct closing the app.",style: Get.textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.green[900],
                            fontSize: 16,height: 1.6
                          ),),
                        ),
                      )

                    ],
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: AppButton(
                            text: "Accept",
                            onClick: () {
                              Get.back();
                              onAccept();
                            })),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                        child: AppButton(
                      text: "Reject",
                      onClick: () {
                        Get.back();
                        onReject();
                      },
                      background: Colors.red,
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
