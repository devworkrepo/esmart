extension OnString on String?{
  String orEmpty()=> (this == null) ? "" : this!;
  String orNA()=> (this == null) ? "N/A" : this!;
}

extension OnString2 on String{
  String orNA()=> (trim().isEmpty) ? "Not Available" : this;
}

