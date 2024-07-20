import 'package:get/get.dart';
import 'package:esmartbazaar/data/repo/home_repo.dart';
import 'package:esmartbazaar/data/repo_impl/home_repo_impl.dart';
import 'package:esmartbazaar/model/common.dart';
import 'package:esmartbazaar/model/profile.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/future_util.dart';

class ProfileController extends GetxController {
  var responseObs = Resource.onInit(data: UserProfile()).obs;
  HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  void onInit() {
    super.onInit();
    _fetchProfileInfo();
  }

  _fetchProfileInfo() async {
    ObsResponseHandler(obs: responseObs, apiCall: repo.fetchProfileInfo());
  }
}
