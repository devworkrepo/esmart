import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/dmt/account_search.dart';

class AccountListDialogWidget extends StatelessWidget {
  final String accountNumber;

  final List<AccountSearch> accountList;
  final Function(AccountSearch) onAccountClick;

  const AccountListDialogWidget(
      {Key? key,
      required this.accountNumber,
      required this.accountList,
      required this.onAccountClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(
              height: 16,
            ),
            _buildList()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.account_balance,
            size: 40,
            color: Get.theme.primaryColorDark,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: Text(
            "Beneficiary Upi Id\n$accountNumber",
            style: Get.textTheme.headline5?.copyWith(color: Colors.black),
          ))
        ],
      ),
    );
  }

  Expanded _buildList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          var account = accountList[index];
          return _buildListItem(account);
        },
        itemCount: accountList.length,
      ),
    );
  }

  Card _buildListItem(AccountSearch account) {
    return Card(
      elevation: 16,
      color: Get.theme.primaryColorDark,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.holderName.toString(),
                  style: Get.textTheme.headline6?.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  account.accountNumber.toString(),
                  style: Get.textTheme.subtitle1?.copyWith(
                      color: Colors.white70, fontWeight: FontWeight.w400),
                ),

                SizedBox(
                  height: 5,
                ),
                Text(
                  "Mobile : " + account.senderNumber.toString(),
                  style: Get.textTheme.bodyText1
                      ?.copyWith(fontWeight: FontWeight.w400,color: Colors.grey[500]),
                ),
              ],
            ),),

            InkResponse(
              onTap: ()=>onAccountClick(account),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.search,size: 30,),
              ),
            )

          ],
        ),
      ),
    );
  }
}
