import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';

import '../../data/repo/home_repo.dart';
import '../../model/notification.dart';
import '../../util/future_util.dart';

class NotificationController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var responseObs = Resource.onInit(data: NotificationResponse()).obs;
  late List<AppNotification> notifications;

  @override
  void onInit() {
    super.onInit();
    _fetchNotifications();
  }

  _fetchNotifications() async {

    result(NotificationResponse response) {
      if (response.code == 1) {
        notifications = response.notifications!;
      }
    }

    ObsResponseHandler(
        obs: responseObs, apiCall: repo.fetchNotification(), result: result);
  }
}