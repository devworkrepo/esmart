import 'package:app_settings/app_settings.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  static Future<bool> storagePermission(){
    return _checkStoragePermissions([Permission.storage]);
  }


   static Future<bool> _checkStoragePermissions(List<Permission> permissions) async {

    var results = await permissions.request();

    List<Permission> permissionDeniedList = [];
    List<Permission> permissionPermanentDeniedList = [];

    results.forEach((permission, permissionStatus) {
      if (permissionStatus.isDenied) {
        permissionDeniedList.add(permission);
      } else if (permissionStatus.isPermanentlyDenied) {
        permissionPermanentDeniedList.add(permission);
      }
    });

    if (permissionPermanentDeniedList.isEmpty &&
        permissionDeniedList.isEmpty) {
      return true;
    }

    if(permissionDeniedList.isNotEmpty){


      showFailureSnackbar(title: "Permission Required", message: "Please grant all permissions");
    }

    if(permissionPermanentDeniedList.isNotEmpty){
      AppSettings.openAppSettings();
    }

    return false;
  }
}
