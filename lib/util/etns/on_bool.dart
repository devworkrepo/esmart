extension OnBool on bool?{
  bool orFalse() {
    if(this == null){
      return false;
    }
    else {
      return this!;
    }
  }
}