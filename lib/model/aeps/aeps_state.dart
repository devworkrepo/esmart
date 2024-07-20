class AepsStateListResponse{
  late int code;
  String? message;
  String? status;
  List<AepsState>? stateList;

  AepsStateListResponse();

  AepsStateListResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    if (json["data"] != null) {
      stateList = List<AepsState>.from(
          json["data"].map((e) => AepsState.fromJson(e)));
    }
  }
}


class AepsState{
  String? name;
  String? id;

  AepsState.fromJson(Map<String,dynamic> json){
    name = json["name"];
    id = json["id"];
  }
}