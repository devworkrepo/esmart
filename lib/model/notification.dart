class NotificationResponse{
  late int code;
  String? message;
  String? status;
  List<AppNotification>? notifications;

  NotificationResponse();

  NotificationResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    message = json["message"];
    status = json["status"];
    notifications = List.from(json["data"]).map((e) => AppNotification.fromJson(e)).toList();
  }
}

class AppNotification{
  String? title;
  String? description;
  String? date;

  AppNotification.fromJson(Map<String,dynamic> json){
    title = json["ticker_txt"];
    description = json["ticker_desc"];
    date = json["addeddate"];
  }
}