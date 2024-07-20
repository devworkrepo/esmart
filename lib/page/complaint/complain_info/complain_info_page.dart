import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/complaint.dart';
import 'package:esmartbazaar/page/complaint/complain_info/complain_info_controller.dart';
import '../../../util/app_constant.dart';

class ComplainInfoPage extends GetView<ComplainInfoController> {
  const ComplainInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ComplainInfoController());
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      controller.isKeyboardOpen.value = false;
    } else {
      controller.isKeyboardOpen.value = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Details"),
      ),
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Column(
          children: [
            if (!controller.isKeyboardOpen.value) _buildInfoSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Comments",
                    style: Get.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
            _listSection(),

            buildAddComment(),
            //  Expanded(child: const ComplainMessageListWidget()),
          ],
        ),
      ),
    );
  }

  Expanded _listSection() {
    return Expanded(
        child: Obx(() => ListView.builder(
            padding: const EdgeInsets.only(bottom: 60),
            controller: controller.commentListController,
            itemCount: controller.commentsObs.length,
            reverse: true,
            itemBuilder: (context, index) {
              ComplaintComment comment = controller.commentsObs[index];
              return _itemChat(
                  context: context,
                  self: int.parse(comment.retailerid!) > 0,
                  message: comment.replydesc!,
                  time: comment.addeddate);
            })));
  }

  Container buildAddComment() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(),
          color: Colors.white70),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(AppConstant.profileBaseUrl +
                controller.appPreference.user.picName.toString()),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: TextField(
            controller: controller.textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Write..",
            ),
          )),

          /*
                ),*/
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                controller.addReply();
              },
              child: const Icon(
                Icons.send,
                color: Colors.blue,
              ))
        ],
      ),
    );
  }

  _itemChat(
      {required BuildContext context,
      required bool self,
      required message,
      time}) {
    return Row(
      mainAxisAlignment: self ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!self)
          const SizedBox(
            width: 100,
          ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: self ? Colors.green : Colors.indigo,
              borderRadius: self
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
            ),
            child: Column(
              crossAxisAlignment: (self)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  '$message',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  '$time',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  (self) ? "You wrote" : "Team respond",
                  style: const TextStyle(color: Colors.white70),
                )
              ],
            ),
          ),
        ),
        if (self)
          const SizedBox(
            width: 100,
          ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/image/arr.png"),
              Text(
                "Ticket# ${controller.complain.ticket_no}",
                style: Get.textTheme.headline6,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow[800]),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.complain.cat_type.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.done_all,
                  color: (controller.complain.isread ?? false)
                      ? Colors.green
                      : Colors.grey,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _buildTitleValue(
              "Created Date", controller.complain.addeddate.toString()),
          _buildTitleValue("Status", controller.complain.status.toString()),
          _buildTitleValue(
              "Transaction No.", controller.complain.transaction_no.toString()),
          _buildTitleValue("Message", controller.complain.full_desc.toString()),
        ],
      ),
    );
  }

  Widget _buildTitleValue(String title, String value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: Get.textTheme.labelLarge,
                )),
            const Text("  :  "),
            Expanded(
                flex: 2,
                child: Text(
                  value,
                  style: Get.textTheme.labelLarge
                      ?.copyWith(color: Colors.grey[800]),
                ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          indent: 0,
        )
      ],
    );
  }
}
