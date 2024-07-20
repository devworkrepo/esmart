import 'package:flutter/material.dart';
import 'package:esmartbazaar/page/dmt/import_beneficiary/from_deleted/import_deleted_page.dart';
import 'package:esmartbazaar/page/dmt/import_beneficiary/from_sender/import_sender_page.dart';

class ImportBeneficiaryTabPage extends StatefulWidget {
  const ImportBeneficiaryTabPage({Key? key}) : super(key: key);

  @override
  _ImportBeneficiaryTabPageState createState() => _ImportBeneficiaryTabPageState();
}

class _ImportBeneficiaryTabPageState extends State<ImportBeneficiaryTabPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(controller: _tabController, children: const [
            ImportFromSenderPage(),
            ImportFromDeletedPage(),
          ]),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 1,
      title: Row(
        children: const [Text("Import Beneficiary"), Icon(Icons.import_export)],
      ),
      bottom: TabBar(controller: _tabController, tabs: const [
        Tab(
          icon: Icon(
            Icons.person_add,
            size: 32,
          ),
          text: "From Remitter",
        ),
        Tab(
          icon: Icon(
            Icons.delete_forever,
            size: 32,
          ),
          text: "Deleted Beneficiary",
        ),
      ]),
    );
  }
}
