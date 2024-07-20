import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenProgressDialogWidget extends StatelessWidget {
  const FullScreenProgressDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                        strokeWidth: 7,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Transaction is being proceed",
                    style:
                        Get.textTheme.headline3?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Please wait",
                    style:
                        Get.textTheme.subtitle1?.copyWith(color: Colors.grey),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
                right: 5,
                left: 5,
                child: Text(
              "Please don't press back button or close app",
              textAlign: TextAlign.center,
              style: Get.textTheme.subtitle2?.copyWith(color: Colors.grey),
            ))
          ],
        ),
      ),
    );
  }
}
