import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/data/repo/recharge_repo.dart';
import 'package:esmartbazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/model/recharge/response.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/api/resource/resource.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/etns/on_string.dart';

class ProviderController extends GetxController {
  ProviderType providerType = Get.arguments;
  var providerTypeObs = ProviderType.prepaid.obs;

  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  AppPreference appPreference = Get.find();

  var providerResponseObs = Resource
      .onInit(data: ProviderResponse())
      .obs;

  late ProviderResponse providerResponse;

  List<Provider> providerList = <Provider>[];

  @override
  void onInit() {
    super.onInit();
    providerTypeObs.value = providerType;
    _fetchProviders();
  }

  _fetchProviders() async {
    try {
      providerResponseObs.value = const Resource.onInit();

      ProviderResponse response = await repo.fetchProviders({
        "type": getProviderInfo(providerType)?.requestParam ?? "",
      });

      if (response.code == 1) {
        providerList = response.providers!;
        searchProviderListObs.value = providerList;
        providerResponse = response;
      }

      providerResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      providerResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onItemClick(Provider provider) {
    var arguments = {
      "transactionNumber" : providerResponse.transactionNumber.orEmpty(),
      "provider": provider,
      "provider_type": providerType,
      "provider_name": getProviderInfo(providerType)?.name ?? "",
      "provider_image": getProviderInfo(providerType)?.imageName ?? "",
    };

    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid ||
        providerType == ProviderType.dth) {
      Get.toNamed(AppRoute.rechargePage, arguments: arguments);
    } else {
      Get.toNamed(AppRoute.billPaymentPage, arguments: arguments);
    }
  }

  RxList<Provider> searchProviderListObs = <Provider>[].obs;

  onSearchChange(String value) async {
    List<Provider> results = providerList;
    if (value.isEmpty) {
      AppUtil.logger(providerList.toString());

      results = providerList;
    } else {
      results = providerList
          .where(
              (user) => user.name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    }
    searchProviderListObs.value = results;
  }

  bool showSearchOption() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid ||
        providerType == ProviderType.dth ||
        providerType == ProviderType.landline) {
      return false;
    } else {
      return true;
    }
  }


  showBillType() {
    return (providerType == ProviderType.postpaid ||
        providerType == ProviderType.prepaid ||
        providerType == ProviderType.insurance ||
        providerType == ProviderType.dth) ? false : true;
  }

  onBillTypeSelect(ProviderType type) {
    providerType = type;
    providerTypeObs.value = type;
    _fetchProviders();
  }

}


class ProviderInfo {
  late String name;
  late String imageName;
  late String requestParam;

  ProviderInfo(this.name, this.requestParam, this.imageName);
}

ProviderInfo? getProviderInfo(ProviderType type) {
  switch (type) {
    case ProviderType.prepaid:
      return ProviderInfo("Prepaid", "prepaid", "mobile");
    case ProviderType.postpaid:
      return ProviderInfo("Postpaid", "Postpaid", "mobile");
    case ProviderType.dth:
      return ProviderInfo("Dth", "dth", "dth");
    case ProviderType.electricity:
      return ProviderInfo("Electricity", "electricity", "electricity");
    case ProviderType.water:
      return ProviderInfo("Water", "water", "water");
    case ProviderType.gas:
      return ProviderInfo("Gas", "gas", "gas");
    case ProviderType.landline:
      return ProviderInfo("LandLine", "Landline Postpaid", "landline");
    case ProviderType.insurance:
      return ProviderInfo("Insurance", "insurance", "insurance");
    default:
      return null;
  }
}