import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/hex_color.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/util/etns/on_bool.dart';

class HomeServiceSection extends GetView<HomeController> {
  final Function(HomeServiceItem) onClick;

  const HomeServiceSection({Key? key, required this.onClick}) : super(key: key);



  _pngPicture(name, int innerPadding) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(300),
        //border: Border.all(color: Get.theme.primaryColorDark,width: 1)
      ),
      //padding:  EdgeInsets.all(innerPadding.toDouble()),
      child: Image.asset("assets/icon/$name.png",height: 48,width: 48,),
    );
  }

  _buildItem(String iconName, String title, HomeServiceType homeServiceType,
      {int innerPadding = 4}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      margin: EdgeInsets.all(4),
      child: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               _pngPicture(iconName, innerPadding),

              Center(
                child: Text(
                  title,
                  style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                  color: HexColor("005f72")),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
         if(homeServiceType == HomeServiceType.upiTransfer)  Positioned(
            right: 4,
              top: 4,
              child: GradientText(
                'Live',
                gradient:  LinearGradient(
                  colors: [
                    Get.theme.primaryColorLight,
                    Colors.purple,
                  ],
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeServiceList = _homeServiceList(controller.user);
    var itemCount = homeServiceList.length;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12, left: 12, right: 12),
      child: Card(
        color: Colors.white.withOpacity(0.9),
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

  Widget _gridTile(HomeServiceItem item, int index) {
    return GestureDetector(
      onTap: () {
        if (item.homeServiceType != HomeServiceType.none) {
          onClick(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: (item.homeServiceType != HomeServiceType.none)
              ? _buildItem(item.iconName, item.title, item.homeServiceType,
                  innerPadding: innerPadding(item))
              : const SizedBox(),
        ),
      ),
    );
  }

  int innerPadding(HomeServiceItem item) {
    // if (item.homeServiceType == HomeServiceType.walletPay ||
    //     item.homeServiceType == HomeServiceType.virtualAccount) {
    //   return 12;
    // } else if (item.homeServiceType == HomeServiceType.lic) {
    //   return 16;
    // } else if (item.homeServiceType == HomeServiceType.paytmWallet) {
    //   return 13;
    // } else if (item.homeServiceType == HomeServiceType.aadhaarPay ||
    //     item.homeServiceType == HomeServiceType.aeps) {
    //   return 10;
    // } else {
    //   return 8;
    // }
    return 8;
  }
}

enum HomeServiceType {
  moneyTransfer,
  payoutTransfer,
  upiTransfer,
  matm,
  aeps,
  aadhaarPay,
  recharge,
  dth,
  billPayment,
  partBillPayment,
  walletPay,
  insurance,
  creditCard,
  lic,
  paytmWallet,
  ott,
  virtualAccount,
  securityDeposity,
  fundAddOnline,
  upiPayment,
  cms,
  newInvestment,
  qrCode,
  none
}

class HomeServiceItem {
  final String title;
  final String iconName;
  final HomeServiceType homeServiceType;

  HomeServiceItem(this.title, this.iconName, this.homeServiceType);
}

List<HomeServiceItem> _homeServiceList(UserDetail user) {
  var isMatm = user.isMatm ?? false;
  var isMatmCredo = user.is_matm_credo ?? false;
  var isMposCredo = user.is_mpos_credo ?? false;
  var isUpi = user.isUpi ?? false;
  var isDmt1 = user.isdmt1 ?? false;
  var isDmt2 = user.isdmt2 ?? false;
  var isDmt3 = user.isdmt3 ?? false;

  List<HomeServiceItem> itemList = [];


  if(isDmt1 || isDmt2 || isDmt3) {
    itemList.add(HomeServiceItem(
      "Money Transfer", "price", HomeServiceType.moneyTransfer));
  }

  if (user.isPayout.orFalse()) {
    itemList.add(HomeServiceItem(
        "Payout Transfer", "money", HomeServiceType.payoutTransfer));
  }

  if (isUpi) {
    itemList.add(HomeServiceItem(
        "Upi Transfer", "upi", HomeServiceType.upiTransfer));
  }

  if (isMatm || isMatmCredo || isMposCredo) {
    itemList.add(HomeServiceItem(
        ((isMatm || isMatmCredo) && isMposCredo)
            ? "Matm / Mpos"
            : (isMposCredo)
                ? "Mpos"
                : "Matm",
        "atm",
        HomeServiceType.matm));
  }
  if (user.isAadhaarPay.orFalse()) {
    itemList.add(
        HomeServiceItem("Aadhaar Pay", "fingerprint-scan", HomeServiceType.aadhaarPay));
  }
  if (user.isAeps.orFalse() || user.isAEPS_F.orFalse()) {
    itemList.add(HomeServiceItem("Aeps", "fingerprint-scan", HomeServiceType.aeps));
  }
  if (user.isRecharge.orFalse()) {
    itemList.add(HomeServiceItem(
        "Mobile\nRecharge", "smartphone", HomeServiceType.recharge));
  }
  if (user.isDth.orFalse()) {
    itemList.add(HomeServiceItem("DTH\nRecharge", "loading_sb", HomeServiceType.dth));
  }
  if (user.isBill.orFalse()) {
    itemList.add(HomeServiceItem(
        "Bill\nPayment", "love", HomeServiceType.billPayment));
  }
  if (user.isBillPart.orFalse()) {
    itemList.add(HomeServiceItem(
        "Part Bill\nPayment", "love", HomeServiceType.partBillPayment));
  }
  if (user.isWalletPay.orFalse()) {
    itemList.add(
        HomeServiceItem("Smart Pay", "wallet", HomeServiceType.walletPay));
  }
  if (user.isInsurance.orFalse()) {
    itemList.add(HomeServiceItem(
        "Loan\nInsurance", "shield", HomeServiceType.insurance));
  }

  if (user.isCreditCard.orFalse()) {
    itemList.add(HomeServiceItem(
        "Pay Credit\nCard Bill", "payment", HomeServiceType.creditCard));
  }
  if (user.isLic.orFalse()) {
    itemList.add(HomeServiceItem("LIC\nPremium", "shield", HomeServiceType.lic));
  }
  if (user.isPaytmWallet.orFalse()) {
    itemList.add(HomeServiceItem(
        "Load Paytm\nWallet", "paytm", HomeServiceType.paytmWallet));
  }
  if (user.isOtt.orFalse()) {
    itemList
        .add(HomeServiceItem("OTT\nSubscription", "video", HomeServiceType.ott));
  }

  if (user.isVirtualAccount ?? false) {
    itemList.add(HomeServiceItem(
        "Virtual\nAccount", "payment-app", HomeServiceType.virtualAccount));
  }

 /* if (user.isSecurityDeposit ?? false) {
    itemList.add(HomeServiceItem("Security\nDeposit", "security_deposit",
        HomeServiceType.securityDeposity));
  }
*/

  if (user.is_pg ?? false) {
    itemList.add(HomeServiceItem("Add Fund\nOnline", "fund_add_online",
        HomeServiceType.fundAddOnline));
  }

 /* if (true) {
    itemList.add(HomeServiceItem("UPI\nPayment", "upi_payment",
        HomeServiceType.upiPayment));
  }
*/
  if (/*todo    user.is_cms ??*/ false) {
    itemList.add(HomeServiceItem("CMS\nService", "cms_service",
        HomeServiceType.cms));
  }

  if ( user.isSecurityDeposit ?? false) {
    itemList.add(HomeServiceItem("Investment", "credit_money",
        HomeServiceType.newInvestment));
  }



  if (user.isQR ?? false) {
    itemList.add(HomeServiceItem("My QR", "qr-code",
        HomeServiceType.qrCode));
  }



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
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
  } else if (length == 1 ||
      length == 4 ||
      length == 7 ||
      length == 10 ||
      length == 13 ||
      length == 16) {
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
  }

  return itemList;
}


class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  GradientText(
      this.text, {
        required this.style,
        required this.gradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}