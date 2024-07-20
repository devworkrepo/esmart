import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';

class BiometricSettingPage extends StatefulWidget {
  const BiometricSettingPage({Key? key}) : super(key: key);

  @override
  State<BiometricSettingPage> createState() => _BiometricSettingPageState();
}

class _BiometricSettingPageState extends State<BiometricSettingPage> {

  final appPreference = Get.find<AppPreference>();

  var isEnable = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isEnable = appPreference.isBiometricAuthentication;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Setting"),
      ),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Biometric Authentication",
                    style: Get.textTheme.subtitle1,
                  )),
                  Switch(value: isEnable, onChanged: (value) {
                    setState(() {
                      isEnable = value;
                      appPreference.setBiometricAuthentication(isEnable);;
                    });
                  })
                ],
              ),
               Text(
                "Enable biometric authentication to secure smart bazaar app login from unknown user.",
                style: TextStyle(color: Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
