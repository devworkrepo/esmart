class QRCode{

  String? upi_id;
  String? upi_pic;
  String? upi_url;

  QRCode.fromJson(Map<String,dynamic> json){
    upi_id = json["upi_id"];
    upi_pic = json["upi_pic"];
    upi_url = json["upi_url"];
  }

}