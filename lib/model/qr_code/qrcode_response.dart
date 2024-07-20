import 'package:esmartbazaar/model/qr_code/qrcod.dart';

class QRCodeListResponse{
  late int code;
  String? status;
  String? message;
  List<QRCode>? qrCodes;

  QRCodeListResponse();

  QRCodeListResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];

    if (json["qrdata"] != null) {
      qrCodes = List.from(json['qrdata'])
          .map((e) => QRCode.fromJson(e))
          .toList();
    }
  }

}