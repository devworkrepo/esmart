class R2RUserResponse {
  late int status;
  late String message;
  bool? hasData;

  R2RUserInfo? data;

  R2RUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    hasData = json['hasData'];
    message = json['message'];
    data = R2RUserInfo.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['hasData'] = hasData;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class R2RUserInfo {
  int? id;
  String? name;
  String? mobile;
  String? shopName;

  R2RUserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['mobile'] = mobile;
    _data['shopName'] = shopName;
    return _data;
  }
}
