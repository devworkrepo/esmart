import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/complaint.dart';
import 'package:esmartbazaar/page/complaint/widget/complaint_filter_dialog.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import 'complaint_list_controller.dart';

class ComplaintListPage extends GetView<ComplaintListController> {
  const ComplaintListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ComplaintListController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ObsResourceWidget<ComplaintListResponse>(
            obs: controller.complainResponseObs,
            childBuilder: (data) => buildBody(data)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () =>
              Get.toNamed(AppRoute.complainPostPage)?.then((value) {
            if (value != null && value is bool) {
              if (value) controller.fetchComplaints();
            }
          }),
          label: const Text("New Complaint"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Column buildBody(ComplaintListResponse data) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildAppbarWidget(),
        if (data.translist!.isNotEmpty)
          Expanded(
            flex: 1,
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100, top: 16),
                itemCount: data.translist!.length,
                itemBuilder: (context, index) {
                  Complaint complaint = data.translist![index];
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Get.toNamed(AppRoute.complainInfoPage,
                        arguments: complaint),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/image/mail.png",
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Ticket# ${complaint.subject_name}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "${complaint.full_desc}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            )
                                          ],
                                        )),
                                        Row(
                                          children: [
                                            Text(
                                              "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[800]),
                                            ),
                                            Icon(
                                              Icons.reply_all_sharp,
                                              size: 24,
                                              color: Colors.grey[800],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.yellow[800]
                                                  ?.withOpacity(0.7)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: Text(
                                            (complaint.cat_type ?? ""),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  complaint.addeddate.toString(),
                                                  style: TextStyle(
                                                      color: Colors.grey[700]),
                                                ),
                                                SizedBox(width: 4,),
                                                Icon(
                                                  Icons.done_all,
                                                  size: 16,
                                                  color:
                                                      (complaint.isread ?? false)
                                                          ? Colors.green
                                                          : Colors.grey[700],
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          indent: 0,
                          color: Colors.grey[300],
                        )
                      ],
                    ),
                  );
                }),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.messenger_outline),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "No complaint found!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                    onPressed: () {
                      controller.refreshList();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.refresh), Text("Refresh")],
                    ))
              ],
            ),
          )
      ],
    );
  }

  Card _buildAppbarWidget() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Complaints",
                      style: Get.textTheme.headline3?.copyWith(
                          color: Get.theme.primaryColorDark,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    ),
                    Obx(() => Text(
                          controller.inbox.value,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.bottomSheet(
                          ComplaintFilterDialog(
                            selectedInbox: controller.inbox.value,
                            selectedCategory: controller.category.value,
                          ),
                          isScrollControlled: true)
                      .then((value) {
                    if (value != null && value is Map) {
                      controller.inbox.value = value["inbox"];
                      controller.category.value = value["category"];
                      controller.fetchComplaints();
                    }
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.blueAccent,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_drop_down),
                        Text(
                          " Filter ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Spacer(),
                Obx(() => Text(
                      controller.category.value,
                      style: TextStyle(
                          color: Colors.grey[700], fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(


              controller: controller.tickNumberController,
              textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.searchTicketNumber();
                      },
                      icon: const Icon(Icons.search),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Enter Ticket #",
                    fillColor: Colors.grey[100]),
            ),
          ],
        ),
      ),
    );
  }
}
