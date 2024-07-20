import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/lifecycle_widget.dart';
import 'package:esmartbazaar/page/main/home/component/home_update_widget.dart';
import 'package:esmartbazaar/route/route_name.dart';
import 'package:esmartbazaar/service/app_lifecycle.dart';
import 'package:esmartbazaar/widget/exception.dart';
import 'package:esmartbazaar/widget/progress.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/component/home_carousel_widget.dart';
import 'package:esmartbazaar/page/main/home/component/home_drawer.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/route_aware_widget.dart';
import 'package:esmartbazaar/page/update_widget.dart';
import 'package:esmartbazaar/util/app_util.dart';

import 'component/home_appbar_section.dart';
import 'component/home_header_section.dart';
import 'component/home_service_section.dart';
import 'package:animated_widgets/animated_widgets.dart';

import 'component/home_service_section_2.dart';
import 'component/investment_summary.dart';

class HomePage extends GetView<HomeController> {
  final Function(UserDetail) userInfo;

  const HomePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return AppLifecycleWidget(
        onResume: () {
          controller.authenticateSecurity();
        },
        child: RouteAwareWidget(
          child: SafeArea(
            child: AppUpdateWidget(
              onAvailable: (isUpdate) {
                controller.isUpdateObs.value = isUpdate;
              },
              child: Scaffold(
                key: controller.scaffoldKey,
                drawer: const HomeDrawerWidget(),
                body: Obx(() => controller.userDetailObs.value.when(
                    onSuccess: (data) {
                      userInfo(data);
                      return _buildSingleChildScrollView();
                    },
                    onFailure: (e) => ExceptionPage(error: e),
                    onInit: (data) => const AppProgressbar())),
              ),
            ),
          ),
          didPopNext: () {
            controller.fetchUserDetails();
          },
          didPush: () {
            controller.fetchUserDetails();
          },
        ));
  }

  Widget _buildSingleChildScrollView() {
    if (controller.user.code == 1) {
      return Stack(
        children: [

          Column(
            children: [
              // HomeAppbarSection(
              //   onDrawerOpen: () {
              //     controller.scaffoldKey.currentState?.openDrawer();
              //   },
              // ),
              Expanded(
                  child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  children: [
                     HomeHeaderSection(openDrawer: ()=>{},),
                    const HomeAppUpdateWidget(),
                    //const HomeCarouselWidget(),
                    _buildAlertMessage(),
                    if (controller.appPreference.user.userType == "Retailer")
                      HomeServiceSection(
                        onClick: (item) => controller.onItemClick(item),
                      ),
                    if (controller.appPreference.user.userType == "Sub-Merchant")   Column(
                      children: [
                        HomeServiceSection2(
                          onClick: (item) => controller.onItemClick2(item),
                        ),
                        HomeCommissionSummaryWidget(),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      );
    } else {
      return ExceptionWidget(Exception(controller.user.message));
    }
  }

  Widget _buildAlertMessage() {
    var response = controller.alertMessageObs.value;
    var alertInfo = response.alert_no ?? "0";
    if (int.parse(alertInfo) > 0) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => Get.toNamed(AppRoute.complaintPage),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
            top: 8,
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  ShakeAnimatedWidget(
                    enabled: true,
                    duration: const Duration(milliseconds: 500),
                    shakeAngle: Rotation.deg(z: 20),
                    curve: Curves.linear,
                    child: Icon(
                      Icons.notifications_on,
                      size: 32,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      response.message.toString(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Colors.red[900],
                          height: 1.2),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
