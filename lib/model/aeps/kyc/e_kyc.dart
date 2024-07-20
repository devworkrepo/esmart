class EKycResponse{
  late int code;
  String? message;
  String? status;
  String? encodeFPTxnId;
  String? primaryKeyId;



  EKycResponse();

  EKycResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    encodeFPTxnId = json['encodeFPTxnId'];
    primaryKeyId = json['primaryKeyId'];
  }
}