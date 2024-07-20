import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/hex_color.dart';

import '../../../../route/route_name.dart';
class HomeHeaderSection extends GetView<HomeController> {

  final Callback openDrawer;

  const HomeHeaderSection({super.key,required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return buildHeaderSection();
  }



  SizedBox buildHeaderSection() {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            height: 186,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                    image: AssetImage("assets/icon/background2.jpg",),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(Colors.purple, BlendMode.modulate)
                )
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Get.theme.primaryColorDark,
              //     Get.theme.primaryColor,
              //     Get.theme.colorScheme.secondary,
              //
              //   ]
              // )
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap : (){
                          controller.scaffoldKey.currentState?.openDrawer();
                        },
                        child: Icon(
                          (Icons.menu_open_rounded),
                          size: 42,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 52,),
                      Spacer(),

                      Row(
                        children: [
                          Image.asset(
                            "assets/icon/sb.png",
                            height: 32,
                          ),
                          Image.asset(
                            "assets/icon/logo2.png",
                            height: 32,
                            width: 120,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child: Row(children: [
                          GestureDetector(
                            onTap: ()=>controller.onSummaryClick(),
                            child: Icon(
                              (Icons.info),
                              size: 38,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5,),
                          GestureDetector(
                            onTap: ()=>controller.onNotificationClick(),
                            child: Icon(
                              (Icons.circle_notifications_outlined),
                              size: 38,
                              color: Colors.white,
                            ),
                          )
                        ],),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child:  Column(
                      children: [
                        SizedBox(height: 12,),
                        Text(
                          "Welcome",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.user.fullName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),

                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                color: Colors.white,
                elevation: 8,
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      buildBalance(title: "Opening Balance",balance: controller.user.openBalance!),
                      buildBalance(title: "Available Balance",balance: controller.user.availableBalance!),

                      // _buildHeaderIcon(
                      //     icon: "assets/icon/vision.png", title: "View\nStatement"),
                      GestureDetector(
                        onTap: ()=>Get.toNamed(AppRoute.fundRequestPage),
                        child: _buildHeaderIcon(
                            icon: "assets/icon/add.png", title: "Add Fund"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildBalance({required String title, required String balance}){
    return  Column(children: [
      Text("₹ $balance",
        style: TextStyle(
            color: Colors.green[700],
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),),
      SizedBox(height: 12,),
      Text(title,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600]

        ),)
    ],);
  }

  Widget _buildHeaderIcon({required Object icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset(icon as String, height: 28, width: 28),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700]),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}




/*class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 0,right: 12,left: 12),
      child: Card(
        color: HexColor("0f1c4c"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             _UserProfileAndCompanyName(),
              _UserBalance()
              
            ],
          ),
        ),
      ),
    );
  }
}



class _UserBalance extends GetView<HomeController> {
  const _UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Available Balance",style: TextStyle(color: HexColor("2ebf14"),fontWeight: FontWeight.w500,fontSize: 16),),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            Image.asset("assets/image/money_bag.png",height: 24,width: 24,color: Colors.white,),
            const SizedBox(width: 8,),
            Text(controller.user.availableBalance ?? "0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 24),),


          ],),
        ),


        if(controller.appPreference.user.isMoneyRequest ?? true)

          if(controller.appPreference.user.userType == "Retailer")GestureDetector(
          onTap: ()=>controller.onAddFundClick(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white70
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                SizedBox(width: 8,),
                Text("Add Fund",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
              ],
            ),
          ),
        )
      ],
    );
  }
}



class _UserProfileAndCompanyName extends GetView<HomeController> {
  const _UserProfileAndCompanyName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 160,
          child: Text(controller.user.outletName.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w500,fontSize: 16),
          ),
        ),

        SizedBox(height: 8,),

        AppCircleNetworkImage(AppConstant.profileBaseUrl+controller.user.picName.toString(),size: 70,),

      ],
    );
  }
}*/

