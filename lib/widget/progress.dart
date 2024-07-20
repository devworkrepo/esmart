import 'package:flutter/material.dart';

class AppProgressbar extends StatelessWidget {

  final dynamic data;

  const AppProgressbar({this.data,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(data != null) return const SizedBox();

    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(100.0),
          )),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
