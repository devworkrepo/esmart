import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/app_update.dart';
import 'package:esmartbazaar/res/style.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/amount_background.dart';


import '../util/in_app_update.dart';

class AppUpdateWidget extends StatefulWidget {
  final Widget child;
  final Function(bool isUpdate)? onAvailable;

  const AppUpdateWidget({Key? key, required this.child, this.onAvailable})
      : super(key: key);

  @override
  _AppUpdateWidgetState createState() => _AppUpdateWidgetState();
}

class _AppUpdateWidgetState extends State<AppUpdateWidget> {
  AppPreference appPreference = Get.find();
  HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //  updateCheck();

      AppUpdateUtil.checkUpdate();
    });
  }

/*  void updateCheck() async {
    VersionStatus? status = Get.find();
    var value = status?.canUpdate ?? false;

    AppUtil.logger("App Update : ${status?.canUpdate ?? false}");
    AppUtil.logger("App Update : ${status?.localVersion}");
    AppUtil.logger("App Update : ${status?.storeVersion}");
    AppUtil.logger("App Update : ${status?.appStoreLink}");

    if (!value) {
      AppUtil.logger("AppUpdate : update not available");

      var currentV = status?.storeVersion;
      var storeV = status?.storeVersion;


      if (currentV == null || storeV == null) return;
      if (currentV.isEmpty || storeV.isEmpty) return;
      if (!currentV.contains(".") && !storeV.contains(".")) return;
      if (currentV == storeV) {
        AppUtil.logger("AppUpdate : update delay time setting up to 0");
        appPreference.setAppUpdateTimeWaiting(0);
      }
      return;
    }

    //callback for app update to child widget
    try {
      AppUtil.logger("AppUpdate : Network app update info on try block");
      NetworkAppUpdateInfo info = await repo.updateInfo();
      _setupUpdate(info,status);
    } catch (e) {
      AppUtil.logger("AppUpdate : Network app update info on catch block");
      _setupUpdate(NetworkAppUpdateInfo(),status);
    }
  }

  _setupUpdate(NetworkAppUpdateInfo info, VersionStatus? status) {
    bool isUpdate = info.isUpdate ?? true;
    bool isForce = info.isForce ?? true;


    if(mounted){
      if (widget.onAvailable != null) widget.onAvailable!(isUpdate);
    }


    AppUtil.logger("AppUpdate : Update is available");
    if (appPreference.appUpdateTimeWaiting > 0) {
      AppUtil.logger("AppUpdateTesting : delay timestamp is greater than zero");
      var savedTime = DateTime.fromMillisecondsSinceEpoch(
              appPreference.appUpdateTimeWaiting)
          .add(_getDelayHourInMilliSecond(info.delayHour));

      if (DateTime.now().isAfter(savedTime)) {
        AppUtil.logger("AppUpdate : on after saved time");


        var playVersion = status?.storeVersion ?? "N/A";
        var currentVersion = status?.localVersion ?? "N/A";

        if (isUpdate) {
          Get.dialog(
            _ShowAppUpdateDialog(
              playVersion: playVersion,
              currentVersion: currentVersion,
              isForce: isForce,
              heading: info.heading,
              description: info.description,
            ),
            barrierDismissible: (isForce) ? false : true,
          );
        }
      }
    } else {
      AppUtil.logger(
          "AppUpdate : Initial timestamp is zero, setting up current timestamp");
      appPreference
          .setAppUpdateTimeWaiting(DateTime.now().millisecondsSinceEpoch);
    }
  }


  Duration _getDelayHourInMilliSecond(String? delayHour) {

    if(delayHour == null) {
      AppUtil.logger("delayHourTesting : delayHour is null : return 2 hour delay");
    }
    if (delayHour == null) return const Duration(hours: 2);



    if (delayHour.startsWith("0") && delayHour.contains(".")) {
      AppUtil.logger("delayHourTesting : delayHour contain 0. : parsing for minutes");
      var newDelayHour = delayHour.substring(2);
      try {
        AppUtil.logger("delayHourTesting : delayHour parsing minute on try block :value $newDelayHour");
        return Duration(minutes: int.parse(newDelayHour));
      } catch (e) {
        AppUtil.logger("delayHourTesting : delayHour parsing minute on catch block : returning 30 minutes");
        return const Duration(minutes: 30);
      }
    } else {
      try {
        AppUtil.logger("delayHourTesting : delayHour parsing hours on try block : returning $delayHour");
        return Duration(hours: int.parse((delayHour)));
      } catch (e) {
        AppUtil.logger("delayHourTesting : delayHour parsing hours on catch block : returning 2 hours");
        return const Duration(hours: 2);
      }
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    var child = widget.child;
    return child;
  }
}

/*class _ShowAppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String playVersion;
  final bool isForce;
  final String? heading;
  final String? description;

  _ShowAppUpdateDialog(
      {required this.currentVersion,
      required this.playVersion,
      required this.isForce,
      this.heading,
      this.description,
      Key? key})
      : super(key: key);

  AppPreference appPreference = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isForce) {
          return false;
        } else {
          return true;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.system_update,
                        size: 70,
                        color: Get.theme.primaryColorDark,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          (heading ?? "").isNotEmpty
                              ? heading!
                              : "App Update Available",
                          style:
                              Get.textTheme.headline6?.copyWith(fontSize: 24),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "New version of app is available in app store please update it.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12,),
                              Text(
                                "Current Version : $currentVersion",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Store Version     : $playVersion",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12,),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(

                                  description ?? "",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
                  const SizedBox(
                    height: 24,
                  ),
                  AppButton(
                      text: "Update",
                      onClick: () {

                        *//*var status = Get.find<VersionStatus?>();
                        if(status?.appStoreLink == null) return;
                        NewVersion().launchAppStore(status?.appStoreLink ?? "");
                        if (currentVersion == playVersion) {
                          Get.back();
                        }*//*
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.bottomSheet(const _UpdateHelpWidget(),
                            isScrollControlled: true);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.help),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Need Help")
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateHelpWidget extends StatelessWidget {
  const _UpdateHelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyle.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "App Update Help ? ",
              style: Get.textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Having problem to update the app. Don't worry we are here to guide you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
            ),
            AmountBackgroundWidget(
                child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Method 1. Goto play store -> Manage apps and device -> Mange -> Updates avaialble",
                      style: Get.textTheme.subtitle2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "If you don't see update available for smart bazaar. Use method 2",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Method 2. Goto Settings -> App Settings -> Find out Google Play Service. Just clear the the cache. Now try to update once more.",
                      style: Get.textTheme.subtitle2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "If you don't see update available for smart bazaar. Use method 3",
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Method 3. Uninstall the smart bazaar app and reinstall from play store.",
                      style: Get.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}*/
