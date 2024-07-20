class SignupStateList{

  String? id;
  String? name;

  SignupStateList();

  SignupStateList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];


  }
}

class SignupStateListResponse{

  late int code;
  late String status;
  late String message;
  late List<SignupStateList> data;

  SignupStateListResponse();

  SignupStateListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = List.from(json["data"]).map((e) => SignupStateList.fromJson(e)).toList();


  }

}