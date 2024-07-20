import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NoItemFoundWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const NoItemFoundWidget(
      {this.message = "No Data Found", this.icon = Icons.search_off, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                icon,
                size: 60,
                color: Colors.black,
              ),
              SizedBox(height: 16,),
              Text(
                message,
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.black),
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
