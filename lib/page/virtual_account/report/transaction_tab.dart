import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:esmartbazaar/page/report/money_report/money_report_page.dart';
import 'package:esmartbazaar/page/report/recharge_report/recharge_report_page.dart';
import 'package:esmartbazaar/page/virtual_account/report/virtual_transaction_report_page.dart';
import 'package:esmartbazaar/util/tags.dart';



class VirtualTransactionTabPage extends StatefulWidget {
  const VirtualTransactionTabPage({Key? key}) : super(key: key);

  @override
  State<VirtualTransactionTabPage> createState() => _VirtualTransactionTabPageState();
}

class _VirtualTransactionTabPageState extends State<VirtualTransactionTabPage>
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
              title: const Text('Virtual Account Transaction'),
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
    var mList = [
      const Tab(text: 'Pending Transaction'),
      const Tab(text: 'All Transaction'),

    ];
    return mList;
  }

  List<Widget> _tabWidgetList() {
    var mList = <Widget>[
      const VirtualTransactionReportPage(
        controllerTag: AppTag.virtualAccountPendingTag,
      ),
      const VirtualTransactionReportPage(
        controllerTag: AppTag.virtualAccountAllTag,
      ),
    ];
    return mList;
  }
}

