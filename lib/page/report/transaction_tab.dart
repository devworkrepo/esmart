import 'package:esmartbazaar/page/report/upi_report/upi_report_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:esmartbazaar/page/report/money_report/money_report_page.dart';
import 'package:esmartbazaar/page/report/recharge_report/recharge_report_page.dart';
import 'package:esmartbazaar/util/tags.dart';

import 'aeps_matm_report/aeps_matm_report_page.dart';

class TransactionTabPage extends StatefulWidget {
  const TransactionTabPage({Key? key}) : super(key: key);

  @override
  State<TransactionTabPage> createState() => _TransactionTabPageState();
}

class _TransactionTabPageState extends State<TransactionTabPage>
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
              title: const Text('Transaction Report'),
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

  List<Tab> _tabList() {
    var mList = <Tab>[];

    var isPayout = appPreference.user.isPayout ?? false;
    var isMpos = appPreference.user.is_mpos_credo ?? false;

    mList.add(const Tab(text: 'DMT'));
    mList.add(const Tab(text: 'UPI'));
    mList.add(const Tab(text: 'AEPS/MATM/Aadhaar Pay'));
    mList.add(const Tab(text: 'Recharge'));
    mList.add(const Tab(text: 'Credit Card'));
    mList.addIf(isPayout, const Tab(text: 'Payout'));
    return mList;
  }

  List<Widget> _tabWidgetList() {
    var isPayout = appPreference.user.isPayout ?? false;
    var isMpos = appPreference.user.is_mpos_credo ?? false;

    var mList = <Widget>[];

    mList.add(const MoneyReportPage(
      controllerTag: AppTag.moneyReportControllerTag,
      origin: "report",
    ));

    mList.add(const UpiReportPage(
      origin: "report",
    ));



    mList.add(const AepsMatmReportPage(
      controllerTag: AppTag.aepsReportControllerTag,
      origin: "report",
    ));


    mList.add(const RechargeReportPage(
      origin: "report",
    ));

    mList.add(const CreditCardReportPage(
      origin: "report",
    ));

    mList.addIf(
        isPayout,
        const MoneyReportPage(
          controllerTag: AppTag.payoutReportControllerTag,
          origin: "report",
        ));
    return mList;
  }
}
