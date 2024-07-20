
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esmartbazaar/widget/status_bar_color_widget.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/util/widget_util.dart';

import 'image.dart';

mixin TransactionPageComponent {

  AppPreference appPreference = Get.find();
  Widget baseTxnResponseWidget(
      {required Widget child,
      required Function onShareClick,
      required int status,
       bool goBack = false,
      }) {
    return WillPopScope(
      onWillPop: () async {
        if(goBack){
          WidgetUtil.statusBarColor(Get.theme.primaryColorDark);
          return goBack;
        }
        else{
          Get.offAllNamed(AppRoute.mainPage);
          return goBack;
        }
      },
      child: StatusBarColorWidget(
        color: getColor(status),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.grey[300],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
              buildCrossButton(() {
                if(goBack){
                  WidgetUtil.statusBarColor(Get.theme.primaryColorDark);
                  Get.back();
                }
                else{
                  Get.offAllNamed(AppRoute.mainPage);
                }
              }),
              Expanded(
                child: Stack(
                  children: [
                    child,

                    buildShareButton(() {
                      onShareClick();
                    }),

                  ],
                ),
              )
            ],),
          ),
        ),
      ),
    );
  }

  Widget appLogo() {
    return Image.asset(
      "assets/image/logo.png",
      height: 50,
    );
  }

  Widget _downloadAndPrint(VoidCallback? onClick) {

    if(onClick == null) return const SizedBox();

    return Positioned(
      bottom: 70,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
             Card(
               color: Colors.blue,
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Row(
                   children: const [
                     Icon(Icons.download_outlined,color: Colors.white,),
                     Padding(
                       padding: EdgeInsets.all(4.0),
                       child: Text(
                         "Download and Print Receipt",
                         style: TextStyle(fontWeight: FontWeight.w400,fontSize: 16,color: Colors.white),
                       ),
                     )
                   ],
                 ),
               ),
             )
            ],
          ),
        ),
      ),
    );
  }

  Widget dividerListContainer(
      {required List<Widget> children, bool topBottom = false}) {
    return Column(
      children: [
        const Divider(
          thickness: 1.5,
          indent: 0,
        ),
        const SizedBox(
          height: 16,
        ),
        ...children,
        const SizedBox(
          height: 16,
        ),
        (topBottom)
            ? const Divider(
                thickness: 1.5,
                indent: 0,
              )
            : const SizedBox()
      ],
    );
  }

  buildStatusIcon(int status) {
    return _AnimateStatusIconWidget(getIcon(status), getColor(status));
  }


  int getStatusIdFromString(String status){
    if (status.toLowerCase() == "success" ||
        status.toLowerCase() == "successful" ||
        status.toLowerCase() == "complete" ||
        status.toLowerCase() == "completed" ||
        status.toLowerCase() == "initiated" ||
        status.toLowerCase() == "accepted") {
      return 1;
    } else if (status.toLowerCase() == "failed" ||
        status.toLowerCase() == "failure" ||
        status.toLowerCase() == "rejected" ||
        status.toLowerCase() == "declined") {
      return 2;
    }
    else if (status.toLowerCase() == "pending") {
      return 3;
    }else {
      return 4;
    }
  }

  Color getColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 34:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.yellow[900]!;
      default:
        return Colors.blue[700]!;
    }
  }

  IconData getIcon(int status) {
    switch (status) {
      case 1:
        return Icons.check_circle;
      case 34:
        return Icons.check_circle;
      case 2:
        return Icons.cancel_outlined;
      case 3:
        return Icons.watch_later_outlined;
      default:
        return Icons.watch_later_outlined;
    }
  }

  String getStatusTitle(int status) {
    switch (status) {
      case 1:
        return "Success";
      case 2:
        return "Failed";
      case 3:
        return "Pending";
      default:
        return "In-Progress";
    }
  }

  Widget buildCrossButton(Function onPressed) {
    return InkResponse(
      onTap: () => onPressed(),
      child: Padding(
        padding: const EdgeInsets.only(top: 24,right: 16),
        child: Image.asset(
          "assets/image/cancel.png",
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  buildStatusTitle(int status, {String? statusDescription}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      child: Text(
        (statusDescription == null)
            ? getStatusTitle(status)
            : statusDescription,
        textAlign: TextAlign.center,
        style: Get.textTheme.headline6?.copyWith(color: getColor(status)),
      ),
    );
  }

  buildMessage(String message) {
    if (message.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyText1?.copyWith(color: Colors.grey),
      ),
    );
  }
  buildTransactionTime(String? time) {
    if (time == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: Get.textTheme.bodyText1?.copyWith(color: Colors.grey),
      ),
    );
  }

  buildTitleValueWidget({required String title, required String value}) {
    if (value.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(title,
                  style: Get.textTheme.headline6
                      ?.copyWith(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 15))),
          Text(
            "  :  ",
            style: Get.textTheme.headline6?.copyWith(fontSize: 14),
          ),
          Expanded(
              flex: 4,
              child: Text(
                value,
                style:
                    Get.textTheme.headline6?.copyWith(color: Colors.black87, fontSize: 15,fontWeight: FontWeight.w500),
              )),
        ],
      ),
    );
  }

  buildShareButton(Function onPressed,{bool left =true}) {
    return Positioned(
      bottom: 16,
      left: 100,
      right: 100,
      child: FloatingActionButton.extended(
        backgroundColor: Get.theme.primaryColorLight,
        foregroundColor: Colors.white,
        onPressed: () => onPressed(),
        label: const Text("Share"),
        icon: const Icon(Icons.share),
      ),
    );
  }

  buildWhatsAppShareButton(Function onPressed,{bool left =true}) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => onPressed(),
        label: const Text("WhatsApp"),
        icon: const Icon(Icons.share),
      ),
    );
  }

  screenshotHelperWidget(
      {required List<Widget> children,
      required ScreenshotController screenshotController}) {
    return SizedBox(

      height: Get.height,
      width: double.infinity,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 130),
        controller: ScrollController(),
        children: [
          Container(
            padding: const EdgeInsets.all(8),

            child: SingleChildScrollView(
              child: Screenshot(
                controller: screenshotController,
                child: Container(

                  padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(

                          image:
                          AssetImage("assets/image/background_receipt.png"),fit: BoxFit.fill),

                    ),
                    child: Column(

                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProviderAndAmount(
      {String? amount,
      String? imageUrl,
      String? imagePath,
      String? imageSvgPath,
      required String title,
      String? subTitle}) {
    if (imagePath != null) {
      if (imageUrl != null || imageSvgPath != null) {
        throw "imageUrl, imagePath and imageSvg only one is required";
      }
    }
    if (imageUrl != null) {
      if (imagePath != null || imageSvgPath != null) {
        throw "imageUrl, imagePath and imageSvg only one is required";
      }
    }

    if (imageSvgPath != null) {
      if (imagePath != null || imageUrl != null) {
        throw "imageUrl, imagePath and imageSvg only one is required";
      }
    }

    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        const Divider(
          thickness: 2,
          indent: 0,
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Get.textTheme.headline4,
                  ),
                  (amount!=null) ? Column(children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "₹ " + amount,
                      style: Get.textTheme.headline6?.copyWith(color: Colors.black,fontSize: 36),
                    )
                  ],) : const SizedBox(),
                  (subTitle!=null)?Column(children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      subTitle,
                      style: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.w500,color: Colors.black54),
                    ),
                  ],): const SizedBox()
                ],
              ),
            ),
            (imagePath != null)
                ? AppCircleAssetPng(
                    imagePath,
                    size: 60,
                    innerPadding: 12,
                  )
                : const SizedBox(),
            (imageUrl != null)
                ? AppCircleNetworkImage(
                    imageUrl,
                  )
                : const SizedBox(),
            (imageSvgPath != null)
                ? AppCircleAssetSvg(
                    imageSvgPath,
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class _AnimateStatusIconWidget extends StatefulWidget {
  final IconData icon;
  final Color color;

  const _AnimateStatusIconWidget(this.icon, this.color, {Key? key})
      : super(key: key);

  @override
  _AnimateStatusIconWidgetState createState() =>
      _AnimateStatusIconWidgetState();
}

class _AnimateStatusIconWidgetState extends State<_AnimateStatusIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animation = Tween<double>(begin: 70, end: 80)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Icon(
        widget.icon,
        color: widget.color,
        size: animation.value,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
