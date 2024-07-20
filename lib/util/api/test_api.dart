import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/service/network_client.dart';

class TestApi {
  static testApi() async {
    NetworkClient client = Get.find();
    var response = await client.get("test-api");
  }

}