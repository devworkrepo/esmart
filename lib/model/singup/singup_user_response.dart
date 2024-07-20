class SignUpUserResponse{
  late int code;
  late String message;
  late String status;
  String? mobileno;
  String? fullname;
  String? address;
  String? emailid;
  String? gender;
  String? dob;
  String? pan_no;
  String? aadhar_no;
  String? picname;

  SignUpUserResponse();
  SignUpUserResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json['status'];
    message = json['message'];
    mobileno = json["mobileno"];
    fullname = json["fullname"];
    address = json["address"];
    emailid = json["emailid"];
    gender = json["gender"];
    dob = json["dob"];
    pan_no = json["pan_no"];
    aadhar_no = json["aadhar_no"];
    picname = json["picname"];
  }
}