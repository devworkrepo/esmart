class SignUpKycDetailResponse{
  late int code;
  late String message;
  late String status;
  String? picname;
  String? name;
  String? dob;
  String? gender;
  String? address;
  String? aadharno;

  SignUpKycDetailResponse();
  SignUpKycDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    picname = json["picname"];
    name = json["name"];
    dob = json["dob"];
    gender = json["gender"];
    address = json["address"];
    aadharno = json["aadharno"];
  }
}