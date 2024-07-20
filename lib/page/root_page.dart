import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.red[900],
        body: Padding(
          padding: const EdgeInsets.only(left: 12,right: 12,top: 48,bottom: 0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.lock_open,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Device is Rooted!",
                        style: Get.textTheme.headline2
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Sorry! your device isn't passing Smart Bazaar's security checks.This "
                        "may be because your device is rooted or is running an un-certified "
                        "or custom OS build. As a result, Smart Bazaar can't confirm that device"
                        " meets Smart Bazaar's security standards.",
                        style: Get.textTheme.subtitle2?.copyWith(
                            color: Colors.white70,
                            wordSpacing: 1.5,
                            height: 1.4),
                      )
                    ],
                  ),
                )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[900]
                        ),
                          onPressed: () {
                        SystemNavigator.pop();
                      }, child: Text("       Exit       ")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
