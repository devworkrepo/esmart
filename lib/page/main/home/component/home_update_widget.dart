import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/widget/common/animate_icon_widget.dart';

class HomeAppUpdateWidget extends GetView<HomeController> {
  const HomeAppUpdateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isUpdateObs.value
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: AppAnimatedWidget(
                          child: CircleAvatar(
                        child: Icon(
                          Icons.system_update,
                        ),
                        radius: 28,
                      )),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Update Available",
                          style: Get.textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "New version of Smart Bazaar is available for update.",
                          style: Get.textTheme.bodyText1
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ],
                    )),
                    ElevatedButton(
                        onPressed: () {
                         /* NewVersion().launchAppStore(
                              Get.find<VersionStatus?>()?.appStoreLink ?? "");*/
                        },
                        child: const Text("Update"))
                  ],
                ),
              ),
            ),
          )
        : const SizedBox());
  }
}
