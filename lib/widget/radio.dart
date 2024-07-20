import 'package:flutter/material.dart';
import 'package:esmartbazaar/util/app_util.dart';


// ignore: must_be_immutable
class AppRadioButton<T> extends StatelessWidget {

  T groupValue;
  final T value;
  final String title;
  final Function(T) onChange;

  AppRadioButton(
      {Key? key,
        required this.groupValue,
        required this.value,
        required this.title,
        required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context,setState){
      return RadioListTile(


        contentPadding: const EdgeInsets.all(0),
        title: Text(title,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
        dense: true,
        value: value,
        groupValue: groupValue,
        onChanged: (T? type) {
          if(type != null){
            groupValue= type;
            onChange(groupValue);
          }
        },
      );
    });
  }
}
