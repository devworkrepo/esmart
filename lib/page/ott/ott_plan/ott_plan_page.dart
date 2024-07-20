import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/ott/ott_plan.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

import 'ott_plan_controller.dart';

class OttPlanPage extends GetView<OttPlanController> {
  const OttPlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OttPlanController());
    return Scaffold(
      appBar: AppBar(title: const Text("OTT Subscription Plan")),
      body: ObsResourceWidget(
        obs: controller.planResponseObs,
        childBuilder: (data) => const _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends GetView<OttPlanController> {
  const _BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mList = controller.planList;
    var itemCount = mList.length;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 12, right: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                  child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return _buildItem(mList[index]);
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  _buildItem(OttPlan plan) {
    _buildText(title, {Alignment alignment = Alignment.center}) => Expanded(
        child: Align(
            alignment: alignment,
            child: Text(
              title,
              style: Get.textTheme.bodyText1?.copyWith(color: Colors.white),
            )));

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: ()=>controller.onItemTab(plan),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 12),
        decoration: BoxDecoration(color: Get.theme.primaryColorDark,borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            _buildText(plan.code, alignment: Alignment.centerLeft),
            _buildText(plan.duration),
            _buildText("₹ "+plan.amount.toString(), alignment: Alignment.centerRight),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    _buildText(title, {Alignment alignment = Alignment.center}) => Expanded(
        child: Align(
            alignment: alignment,
            child: Text(
              title,
              style: Get.textTheme.subtitle1,
            )));

    return Column(
      children: [
        Row(
          children: [
            _buildText("Plan Name", alignment: Alignment.centerLeft),
            _buildText("Duration"),
            _buildText("Amount", alignment: Alignment.centerRight),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Divider(
          indent: 0,
        ),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
