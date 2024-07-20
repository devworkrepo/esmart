class NewsResponse {
  NewsResponse();
  late final int status;
  late final String message;
  String? retailerNews;
  String? distributorNews;

  NewsResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    retailerNews = json['retailer_news'];
    distributorNews = json['distributor_news'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['retailer_news'] = retailerNews;
    _data['distributor_news'] = distributorNews;
    return _data;
  }
}