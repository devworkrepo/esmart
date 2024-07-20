import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class PermissionService {
  static Future<bool> checkBluetoothPermission() async {
    var result =
        await [Permission.bluetoothScan, Permission.bluetoothConnect].request();

    var isPermanentlyDenied = false;
    var isDenied = false;

    result.forEach((permission, permissionStatus) {
      if (permissionStatus.isPermanentlyDenied) {
        isPermanentlyDenied = true;
      }
      if (permissionStatus.isDenied) {
        isDenied = true;
      }
    });

    if (!isPermanentlyDenied && !isDenied) {
      return true;
    } else if (isPermanentlyDenied) {
      StatusDialog.alert(title: "Grant bluetooth permission from app setting !")
          .then((value) => AppSettings.openAppSettings());
      return false;
    } else {
      StatusDialog.alert(
          title:
              "Bluetooth permission is required to access further feature !");
      return false;
    }
  }
}
