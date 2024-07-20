import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/dialog/location.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

enum LocationError {
  locationNotEnable,
  permissionIsPermanentlyDenied,
  permissionIsDenied
}

class LocationService {
  static Future<Position> determinePosition(
      {String title = "Validating Location", bool progress = true}) async {
    LocationPermission permission;

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      /* Get.to(
        () => const LocationDialog(
            locationError: LocationError.permissionIsDenied),
        fullscreenDialog: true,
      );*/
      return Future.error(LocationError.permissionIsDenied);
    } else if (permission == LocationPermission.deniedForever) {
      await Get.to(
        () => const LocationDialog(
            locationError: LocationError.permissionIsPermanentlyDenied),
        fullscreenDialog: true,
      );
      return Future.error(LocationError.permissionIsPermanentlyDenied);
    } else {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if(Get.isSnackbarOpen){
        Get.closeAllSnackbars();
      }
      if (!serviceEnabled) {
        if (progress) StatusDialog.progress(title: title);
        try {
          var result = await Geolocator.getCurrentPosition();
          if (progress) Get.back();
          return result;
        } catch (e) {
          if (progress) Get.back();
          return Future.error(LocationError.locationNotEnable);
        }
      } else {
        if (progress) StatusDialog.progress(title: title);
        var result = await Geolocator.getCurrentPosition();
        if (progress) Get.back();
        return result;
      }
    }
  }
}
