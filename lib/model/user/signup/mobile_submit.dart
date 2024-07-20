class SignupCommonResponse {
  SignupCommonResponse();
  late final int status;
  late final String message;
  String? mobile;
  String? email;
  int? requestId;
  SignupDetail? details;

  SignupCommonResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    mobile = json['mobile'];
    email = json['email_id'];
    requestId = json['requestId'];
    if(json["details"]!= null) {
      details = SignupDetail.fromJson(json['details']);
    }
  }
}

class SignupDetail {
  SignupDetail();
  String? name;
  String? email;
  String? panCard;
  String? mobile;

  SignupDetail.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    panCard = json['pan_card'];
    mobile = json['mobile'];
  }

}