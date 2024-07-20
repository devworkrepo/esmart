class DmtBank{
  String? ifsc;
  String? bankName;

  DmtBank.fromJson(Map<String,dynamic> json){
    ifsc = json["ifsc"].toString();
    bankName = json["bank_name"];
  }
}