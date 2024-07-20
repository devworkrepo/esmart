import 'package:app_settings/app_settings.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  static Future<bool> cameraPermission() async {
    var result =  await Permission.camera.request();
    if(result.isGranted){
      return true;
    }
    else if(result.isPermanentlyDenied == true){
      StatusDialog.alert(title: "Camera permission is required to access this feature!").then((value){
        AppSettings.openAppSettings();
      });
      return false;
    }
    else {
      return false;
    }

  }


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
