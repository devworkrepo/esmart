import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/login_session.dart';
import 'package:esmartbazaar/page/app_setting/login_session_controller.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import '../../widget/no_data_found.dart';

class LoginSessionPage extends GetView<AppSettingController> {
  const LoginSessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AppSettingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Login Sessions"),
      ),
      body: ObsResourceWidget(
        obs: controller.responseObs,
        childBuilder: (data) => (controller.sessions.isEmpty)
            ? const NoItemFoundWidget(
          icon: Icons.phone_android,
          message: "No active device found",
        )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: controller.sessions.length,
                    itemBuilder: (context, index) {
                      return _BuildListItem(
                          controller.sessions[index]);
                    }),
              ),
      ),
    );
  }
}


class _BuildListItem extends GetView<AppSettingController> {
  final LoginSession session;

  const _BuildListItem(this.session, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (controller.appPreference.sessionKey ==
                              session.active_id)
                            Icon(Icons.verified),
                          Expanded(
                              child: Text(
                            session.device_name.toString(),
                            style: Get.textTheme.headline6?.copyWith(
                                color: Get.theme.primaryColorDark,
                                fontSize: 18),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "IP Address   : " + session.ip_address.toString(),
                        style: Get.textTheme.subtitle1?.copyWith(fontSize: 15),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Device Type : " + session.device_type.toString(),
                        style: Get.textTheme.subtitle1?.copyWith(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controller.killSession(session),
                  child: const Text("Logout"),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Login Date  : "),
                    Text(session.login_date.toString()),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Text("Expiry Date : "),
                    Text(session.expiry_date.toString()),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
