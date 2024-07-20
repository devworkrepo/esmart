import 'dart:convert';

class AppConfig {
  static const String encodedNetworkKey =
      "WXpOQ2FHVlhWbXRhTTFGcVRXcENiMWxYTVdoWlVUMDk=";

  static const String encodedApiCode =
      "VlROQ2FHVlRUa0pqU0VKQlRXcEJlVTFCUFQwPQ==";

  static const String encodedApiKey =
      "VVZkMFdtSnRVWHBOYkU1dlRWUkpOVlJ0TVhGYVJ6UTk=";

  static const String encodedSecretKey =
      "VkRCNGExTkVRbGxWVkd4TldqQnNNV1J1YjNKV2JYQnRVM2s1ZFZGVU1Eaz0=";



  static String networkKey = "";
  static String apiCode = "";
  static String apiKey = "";
  static String secretKey = "";

  static init() {
    networkKey =  _decodedValue(encodedNetworkKey);
    apiCode = "ESPL#App@2023";//_decodedValue(encodedApiCode);
    apiKey = "GaNnd32Sh879BajraHn";//_decodedValue(encodedApiKey);
    secretKey = _decodedValue(encodedSecretKey);
  }


  static String _decodedValue(String value) {
    var decodedValue = value;
    for (int i = 0; i < 3; i++) {
      decodedValue = utf8.decode(base64.decode(decodedValue));
    }
    return decodedValue;
  }
}
