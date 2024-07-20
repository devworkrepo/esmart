import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/util/etns/on_bool.dart';

class HomeServiceSection2 extends GetView<HomeController> {
  final Function(HomeServiceItem2) onClick;

  const HomeServiceSection2({Key? key, required this.onClick})
      : super(key: key);



  _pngPicture(name, int innerPadding) {
    return AppCircleAssetPng(
      "assets/image/$name.png",
      size: 60,
      innerPadding: innerPadding,
    );
  }

  _buildItem(String iconName, String title, HomeServiceType2 homeServiceType,
      {int innerPadding = 4}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      _pngPicture(iconName, innerPadding),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeServiceList = _homeServiceList(controller.user);
    var itemCount = homeServiceList.length;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 0, left: 12, right: 12),
      child: Card(
        child: GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          children: List.generate(
            itemCount,
            (index) => _gridTile(homeServiceList[index], index),
          ),
        ),
      ),
    );
  }

  Widget _gridTile(HomeServiceItem2 item, int index) {
    return GestureDetector(
      onTap: () {
        if (item.homeServiceType != HomeServiceType2.none) {
          onClick(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                color: (index == 0 || index == 1 || index == 2)
                    ? Colors.transparent
                    : Colors.black54,
                width: 0.5,
              ),
              left: BorderSide(
                color: (index == 0 || index % 3 == 0)
                    ? Colors.transparent
                    : Colors.black54,
                width: 0.5,
              )),
        ),
        child: Center(
          child: (item.homeServiceType != HomeServiceType2.none)
              ? _buildItem(item.iconName, item.title, item.homeServiceType,
                  innerPadding: innerPadding(item))
              : const SizedBox(),
        ),
      ),
    );
  }

  int innerPadding(HomeServiceItem2 item) {
    if (
       item.homeServiceType == HomeServiceType2.accountStatement
    ) {
      return 12;
    } else {
      return 8;
    }
  }
}

enum HomeServiceType2 {
  createInvestment,
  investmentList,
  accountStatement,
  addFundOnline,
  fundHistory,
  investmentSummary,
  none
}

class HomeServiceItem2 {
  final String title;
  final String iconName;
  final HomeServiceType2 homeServiceType;

  HomeServiceItem2(this.title, this.iconName, this.homeServiceType);
}

List<HomeServiceItem2> _homeServiceList(UserDetail user) {
  List<HomeServiceItem2> itemList = [];

  itemList.add(HomeServiceItem2("Create Investment", "credit_money",
      HomeServiceType2.createInvestment));
  itemList.add(HomeServiceItem2(
      "Investment List", "investment_list", HomeServiceType2.investmentList));

  itemList.add(HomeServiceItem2("Account Statement", "statement",
      HomeServiceType2.accountStatement));
  itemList.add(HomeServiceItem2(
      "Add Fund Online", "fund_add_online", HomeServiceType2.addFundOnline));

  itemList.add(HomeServiceItem2(
      "Fund History", "fund_add_pending", HomeServiceType2.fundHistory));


  itemList.add(HomeServiceItem2(
      "Investment\nSummary", "summary", HomeServiceType2.investmentSummary));



  var length = itemList.length;

  if (length == 3 ||
      length == 6 ||
      length == 9 ||
      length == 12 ||
      length == 15 ||
      length == 18) {
  } else if (length == 2 ||
      length == 5 ||
      length == 8 ||
      length == 11 ||
      length == 14 ||
      length == 17) {
    itemList.add(HomeServiceItem2("", "", HomeServiceType2.none));
  } else if (length == 1 ||
      length == 4 ||
      length == 7 ||
      length == 10 ||
      length == 13 ||
      length == 16) {
    itemList.add(HomeServiceItem2("", "", HomeServiceType2.none));
    itemList.add(HomeServiceItem2("", "", HomeServiceType2.none));
  }

  return itemList;
}
