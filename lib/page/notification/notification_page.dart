import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/no_data_found.dart';
import 'package:esmartbazaar/model/notification.dart';
import 'package:esmartbazaar/page/notification/notification_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(
      body: ObsResourceWidget(
          obs: controller.responseObs, childBuilder: (data) => _BuildBody()),
    );
  }
}

class _BuildBody extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return (controller.notifications.isEmpty)
        ? const NoItemFoundWidget()
        : ListView.builder(
            itemCount: controller.notifications.length+1,
            itemBuilder: (context, index) {
              if(index == 0){
              return   _buildAppbarWidget();
              }
              else{
                return _BuildListItem(controller.notifications[index-1]);
              }
            });
  }

  Padding _buildAppbarWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
          RichText(
              text: TextSpan(
                  text: "Notification",
                  style: Get.textTheme.headline3?.copyWith(
                      color: Get.theme.primaryColorDark,
                      fontSize: 32,
                      fontWeight: FontWeight.w500),
                 )),
        ],
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final AppNotification notification;

  const _BuildListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? "",
                style: Get.textTheme.headline6
                    ?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12,),
              Text(
                notification.description ?? "",
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.grey[700]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
