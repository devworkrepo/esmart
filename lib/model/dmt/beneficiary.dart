import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Beneficiary {
  String? id;
  String? tramobid;
  String? name;
  String? accountNumber;
  String? bankName;
  String? ifscCode;
  String? senderNumber;
  String? validateStatus;
  String? bank_pic;
  RxBool isExpanded = false.obs;
  RxBool isSelectedForImport = false.obs;

  bool get bankVerified {
    return (validateStatus == null)
        ? false
        : (validateStatus!.toLowerCase() == "success" || validateStatus!.toLowerCase() == "true")
            ? true
            : false;
  }

  Beneficiary._();

  Beneficiary.fromMap(Map<String, dynamic> json) {
    id = json["beneid"];
    name = json["name"];
    accountNumber = json["accountno"];
    bankName = json["bank"];
    ifscCode = json["ifsc"];
    senderNumber = json["remitter_mobile"];
    validateStatus = json["validate_status"];
    bank_pic = json["bank_pic"];
  }
}
