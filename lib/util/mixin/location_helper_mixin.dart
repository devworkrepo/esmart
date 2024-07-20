import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/service/location.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

import '../../service/location.dart';

mixin LocationHelperMixin {
  Position? position;
  var latitude = "".obs;
  var longitude = "".obs;

  Future<bool> validateLocation({bool progress = true}) async {
    if (position != null) {
      latitude.value = position!.latitude.toString();
      longitude.value = position!.longitude.toString();
      return true;
    }

    try {
      position = await LocationService.determinePosition(progress: progress);
      if(position != null){
        latitude.value = position!.latitude.toString();
        longitude.value = position!.longitude.toString();
      }
      return (position == null) ? false : true;
    } catch (e) {
      if (e is LocationError) {
        if (e == LocationError.permissionIsDenied) {
          await StatusDialog.alert(title: "Permission denied! please grant the permission to access further features.");
        }
        else if(e  == LocationError.locationNotEnable){
          await StatusDialog.alert(title: "Location not enable! please enable location to access further feature");
        }
      }
      return false;
    }
  }
}
