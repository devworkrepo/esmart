

class RechargePlan {
  String rs = "";
  String desc= "";

  RechargePlan();

  RechargePlan.fromJson(Map<String, dynamic> json) {
    rs = json['rs'].toString();
    desc = json['desc'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rs'] = rs;
    data['desc'] = desc;
    return data;
  }
}
