class PgPaymentModeResponse {
  late int code;
  late String message;
  late String status;
  List<PgPaymentMode>? chglist;

  PgPaymentModeResponse();

  PgPaymentModeResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    chglist = List.from(json["chglist"])
        .map((e) => PgPaymentMode.fromJson(e))
        .toList();
  }
}

class PgPaymentMode {
  String? mode_name;
  String? mode_code;
  String? channel_name;
  String? free_upto;
  String? charge_from_amt;
  String? charge_percent;
  String? charge_adon;

  PgPaymentMode();

  PgPaymentMode.fromJson(Map<String, dynamic> json) {
    mode_name = json["mode_name"];
    mode_code = json["mode_code"];
    channel_name = json["channel_name"];
    free_upto = json["free_upto"];
    charge_from_amt = json["charge_from_amt"];
    charge_percent = json["charge_percent"];
    charge_adon = json["charge_adon"];
  }
}
