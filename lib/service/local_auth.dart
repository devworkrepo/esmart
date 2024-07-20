import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../page/main/home/home_controller.dart';

class LocalAuthService {
  static Future<bool> isAvailable() async {
    try {
      bool canCheckBiometrics = await LocalAuthentication().isDeviceSupported();
      return canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {

    if (await isAvailable()) {
      try {
        var isAuthenticate = await LocalAuthentication().authenticate(
            stickyAuth: true,
            localizedReason:
                "Access app with biometric authentication is more secure");

        if (!isAuthenticate) {
          isLocalAuthDone = false;
          SystemNavigator.pop();
          return false;
        } else {
          return true;
        }
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }
}
