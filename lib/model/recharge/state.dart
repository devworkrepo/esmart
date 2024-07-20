import 'package:flutter/cupertino.dart';

class CountryState{
  late String name;
  late int id;

  CountryState._();

  CountryState.fromMap(Map<String,dynamic> json){
    name = json['name'];
    id = json['id'];
  }
}