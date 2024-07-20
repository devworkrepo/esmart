enum DmtType{
  instantPay,
  payout
}


class DmtHelper{
  static String getAppbarTitle(DmtType dmtType) {
    if (dmtType == DmtType.instantPay) {
      return "Money Transfer";
    }
    else if(dmtType == DmtType.payout){
      return "Payout Transfer";
    }
    else {
      return "Not Implemented Type";
    }
  }

}

enum DmtTransferType{
  imps, neft
}