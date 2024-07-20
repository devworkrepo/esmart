import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common/animate_icon_widget.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/res/color.dart';

class HomeAppbarSection extends GetView<HomeController> {
  final VoidCallback onDrawerOpen;

  const HomeAppbarSection({Key? key, required this.onDrawerOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Card(
      margin: EdgeInsets.zero,
      shadowColor: Colors.blue.withOpacity(controller.appbarBackgroundOpacity.value),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: controller.appbarElevation.value,
      color: Colors.white.withOpacity(controller.appbarBackgroundOpacity.value),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Card(
              color:Colors.white,
              shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              child: IconButton(
                  onPressed: onDrawerOpen,
                  icon:  Icon(
                    Icons.menu,
                    size: 24,
                    color: Get.theme.primaryColorDark,
                  )),
            ),
            const SizedBox(
              width: 12,
            ),
            AppAnimatedWidget(
              child: Image.asset(
                "assets/image/logo.png",
              ),
            ),
            const Spacer(),


            if (controller.appPreference.user.userType == "Retailer")   IconButton(
              color: Get.theme.primaryColorDark,
              iconSize: 32,
              onPressed: ()=>controller.onSummaryClick(),
              icon: const Icon(Icons.info),
            ),
            IconButton(
              color: Get.theme.primaryColorDark,
              iconSize: 32,
              onPressed: ()=>controller.onNotificationClick(),
              icon: const Icon(Icons.notifications_active),
            ),

          ],
        ),
      ),
    ));
  }
}
