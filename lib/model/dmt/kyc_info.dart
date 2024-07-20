class KycInfoResponse{
  late int code;
  late String message;
  String? status;
  String? name;
  String? picName;
  String? dob;
  String? gender;
  String? address;
  String? aadhaarNumber;

  KycInfoResponse();

  KycInfoResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    name = json["name"];
    picName = json["picname"];
    dob = json["dob"];
    gender = json["gender"];
    address = json["address"];
    aadhaarNumber = json["aadharno"];

  }
}