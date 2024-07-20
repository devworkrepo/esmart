import 'package:esmartbazaar/page/refund/upi_refund/upi_refund_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/refund/credit_card_refund/credit_card_refund_page.dart';
import 'package:esmartbazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:esmartbazaar/page/refund/recharge_refund/recharge_refund_page.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/util/tags.dart';

import 'dmt_refund/dmt_refund_page.dart';


class RefundTabPage extends StatefulWidget {

  const RefundTabPage( {Key? key}) : super(key: key);

  @override
  State<RefundTabPage> createState() => _RefundTabPageState();
}

class _RefundTabPageState extends State<RefundTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList().length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext mContext, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: const Text('Refund Pending'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: _tabList(),
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabWidgetList(),
        ),
      ),
    );
  }

  List<Widget> _tabWidgetList() {
    var mList =   <Widget>[
          const DmtRefundPage(controllerTag: AppTag.moneyRefundControllerTag,origin: "report",),
          const UpiRefundPage(origin: "report",),
          const RechargeRefundPage(origin: "report",),
          const CreditCardRefundPage(origin: "report",)
        ];
    if(appPreference.user.isPayout ?? false){
      mList.add( const DmtRefundPage(controllerTag: AppTag.payoutRefundControllerTag,origin: "report",),);
    }
    return mList;
  }

  List<Tab> _tabList() {
    var mList =  <Tab>[
                const Tab(text: 'Money Transfer'),
                const Tab(text: 'UPI'),
                const Tab(text: 'Utility'),
                const Tab(text: 'Credit Card'),
              ];

    if(appPreference.user.isPayout ?? false){
      mList.add(const Tab(text: "Payout",));
    }
    return mList;
  }
}

