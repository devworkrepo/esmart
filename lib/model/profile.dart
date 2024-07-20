class UserProfile{

  String? address;
  String? cityname;
  late int  code;
  String? distributor_mobile;
  String? distributor_name;
  String? dob;
  String? emailid;
  String? fullname;
  String? isactive;
  String? isblock;
  String? message;
  String? outlet_address;
  String? outlet_code;
  String? outlet_mobile;
  String? outlet_name;
  String? pan_no;
  String? pincode;
  String? state_name;
  String? status;
  String? usertype;


  UserProfile();

  UserProfile.fromJson(Map<String,dynamic> json){
    address = json["address"];
    cityname = json["cityname"];
    code = json["code"];
    distributor_mobile = json["distributor_mobile"];
    distributor_name = json["distributor_name"];
    dob = json["dob"];
    emailid = json["emailid"];
    fullname = json["fullname"];
    isactive = json["isactive"];
    isblock = json["isblock"];
    message = json["message"];
    outlet_address = json["outlet_address"];
    outlet_code = json["outlet_code"];
    outlet_mobile = json["outlet_mobile"];
    outlet_name = json["outlet_name"];
    pan_no = json["pan_no"];
    pincode = json["pincode"];
    state_name = json["state_name"];
    status = json["status"];
    usertype = json["usertype"];
  }

}