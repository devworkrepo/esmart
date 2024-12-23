enum DmtType{
  instantPay,
  payout,
  dmt2,
  dmt3
}


class DmtHelper{
  static String getAppbarTitle(DmtType dmtType) {
    if (dmtType == DmtType.instantPay) {
      return "Money Transfer 1";
    }
    else  if (dmtType == DmtType.dmt2) {
      return "Money Transfer 2";
    }
    else  if (dmtType == DmtType.dmt3) {
      return "Money Transfer 3";
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