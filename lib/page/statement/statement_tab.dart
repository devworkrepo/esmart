import 'package:flutter/material.dart';
import 'package:esmartbazaar/page/statement/account_statement/account_statement_page.dart';
import 'package:esmartbazaar/page/statement/credit_debit/credit_debit_page.dart';
import 'package:esmartbazaar/util/tags.dart';



class StatementTabPage extends StatefulWidget {
  const StatementTabPage({Key? key}) : super(key: key);

  @override
  State<StatementTabPage> createState() => _StatementTabPageState();
}

class _StatementTabPageState extends State<StatementTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext mContext, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: const Text('Statement Report'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: const <Tab>[
                  Tab(text: 'Account'),
                  Tab(text: 'Aeps'),
                  Tab(text: 'Credit/Debit'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            AccountStatementPage(controllerTag: AppTag.accountStatementControllerTag,),
            AccountStatementPage(controllerTag: AppTag.aepsStatementControllerTag,),
            CreditDebitPage(controllerTag: AppTag.creditStatementControllerTag,),
          ],
        ),
      ),
    );
  }
}

