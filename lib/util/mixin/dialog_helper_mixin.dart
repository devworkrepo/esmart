import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

mixin DialogHelperMixin {
  Widget buildBaseContainer({required Widget child,required String title}) {
   return  BaseDialogContainer(
      backPress: true,
      padding: 30,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:Stack(
          children: [
            buildCrossButton(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: buildTitleWidget(title)),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  child: child,
                  width: Get.width,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTitleWidget(String title){
    return Text(title,style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.w500),);
  }

  Widget buildCrossButton() {
    return Positioned(
        top: 0,
        right: 0,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.cancel,
            size: 32,
            color: Colors.red,
          ),
        ));
  }
}
