extension OnInt on int?{
  String toStringNa() {
    if(this == null){
      return "NA";
    }
    else {
      return this!.toString();
    }
  }

  String nullToString() {
    if(this == null){
      return "";
    }
    else {
      return this!.toString();
    }
  }
}