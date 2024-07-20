class AppBanner {
  String? picName;
  String? rawPicName;

  AppBanner({this.rawPicName});

  AppBanner.fromJson(Map<String, dynamic> json) {
    picName = json["picname"];
  }
}

class BannerResponse {
  late int code;
  String? status;
  String? message;
  List<AppBanner>? banners;

  BannerResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    banners = List.from(json["data"]).map((e) => AppBanner.fromJson(e)).toList();
  }
}
