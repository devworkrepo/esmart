class QRInfoResponse {
  late final List<String> notes;
  late final  QRInfo data;

  QRInfoResponse();

  QRInfoResponse.fromJson(Map<String, dynamic> json) {
    notes = List.castFrom<dynamic, String>(json['notes']);
    data = QRInfo.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notes'] = notes;
    _data['data'] = data.toJson();
    return _data;
  }
}

class QRInfo {
  QRInfo({
    required this.status,
    required this.message,
    required this.upiCode,
    required this.refId,
    required this.outletName,
  });

  late final int status;
  late final String message;
  late final String upiCode;
  late final String refId;
  late final String outletName;

  QRInfo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    upiCode = json['upi_code'];
    refId = json['ref_id'];
    outletName = json['outlet_name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['upi_code'] = upiCode;
    _data['ref_id'] = refId;
    _data['outlet_name'] = outletName;
    return _data;
  }
}
