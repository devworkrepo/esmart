extension OnList on List? {
  bool isTrueList() {
    if (this == null) {
      return false;
    } else if (this!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
