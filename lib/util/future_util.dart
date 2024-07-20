import 'package:get/get.dart';

import '../page/exception_page.dart';
import 'api/resource/resource.dart';





class ObsResponseHandler<T>{

  final Rx<Resource<T>> obs;
  final Future apiCall;
  final Function(T)? result;


  ObsResponseHandler(
      {required this.obs, required this.apiCall, this.result}) {
    _call();
  }

  _call() async {
    obs.value = const Resource.onInit();
    try {
      T response = await apiCall;
      if (result != null) {
        result!(response);
      }
       obs.value = Resource.onSuccess(response);
     } catch (e) {
       obs.value = Resource.onFailure(e);
       Get.off(ExceptionPage(error: e));
     }
   }


}

obsResponseHandler<T>(
    {required Rx<Resource<T>> obs,
    required Future apiCall,
    required Function(T) onResponse}) async {
  obs.value = const Resource.onInit();
  try {
    T response = await apiCall;
    onResponse(response);
    obs.value = Resource.onSuccess(response);
  } catch (e) {
    obs.value = Resource.onFailure(e);
    Get.off(ExceptionPage(error: e));
  }
}
