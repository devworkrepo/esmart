

class Provider {
  late String name;
  late String id;
  late String operatorCode;

  Provider();
  Provider.fromJson2(Map<String, dynamic> json) {
    name = json['name'].toString();
    id = json['id'].toString();
    operatorCode = json['opcode'].toString();
  }

  Provider.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    id = json['id'].toString();
    operatorCode = json['opcode'].toString();
  }

}


class RechargeCircle {
  late String name;
  late String id;

  RechargeCircle();

  RechargeCircle.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    id = json['id'].toString();
  }

}
