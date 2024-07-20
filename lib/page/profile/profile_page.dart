import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/model/profile.dart';
import 'package:esmartbazaar/model/user/user.dart';
import 'package:esmartbazaar/page/profile/profile_controller.dart';
import 'package:esmartbazaar/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/obx_widget.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Profile"),
      ),
      body: ObsResourceWidget<UserProfile>(
          obs: controller.responseObs,
          childBuilder: (data) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [_UserInfoSection(data),
                      _GeneralInfo(data),
                      _AddressInfo(data),
                      _ParentInfo(data),

                    ],
                  ),
                ),
              )),
    );
  }
}

// ignore: must_be_immutable
class _UserInfoSection extends StatelessWidget {

  final UserProfile profile;

  _UserInfoSection(this.profile,{Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: Get.width,
              decoration: BoxDecoration(color: Get.theme.primaryColorDark),
              child: Column(
                children: [
                  AppCircleNetworkImage(
                    AppConstant.profileBaseUrl + (user.picName ?? ""),
                    size: 80,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    (profile.outlet_name ?? ""),
                    style:
                    Get.textTheme.headline6?.copyWith(color: Colors.white),
                  ),
                  Text(
                    (user.fullName ?? ""),
                    style:
                    Get.textTheme.headline6?.copyWith(color: Colors.white70),
                  ),

                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Code - " + (user.agentCode ?? ""),
                    style: Get.textTheme.bodyText1
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _BuildTitleValueWidget("Available Bal","₹  "+ user.availableBalance.toString()),
                  _BuildTitleValueWidget("Opening Bal","₹  "+ user.openBalance.toString()),
                  _BuildTitleValueWidget("Credit Bal","₹  "+ user.creditBalance.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class _BuildTitleValueWidget extends StatelessWidget {
  final String title;
  final String? value;
  const _BuildTitleValueWidget(this.title,this.value,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          BuildTitleValueWidget(
            title: title,
            value: value ?? "",
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),

          Divider(indent: 0,color: Colors.grey[400],)
        ],
      ),
    );
  }
}



class _GeneralInfo extends StatelessWidget {

  final UserProfile profile;

  _GeneralInfo(this.profile,{Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _BuildTitleValueWidget("Mobile Number", profile.outlet_mobile),
                  _BuildTitleValueWidget("Email ID", profile.emailid),
                  _BuildTitleValueWidget("Pan Number", profile.pan_no),
                  _BuildTitleValueWidget("DOB", profile.dob),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class _AddressInfo extends StatelessWidget {

  final UserProfile profile;

  _AddressInfo(this.profile,{Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _BuildTitleValueWidget("State Name", profile.state_name),
                  _BuildTitleValueWidget("Address", profile.address),
                  _BuildTitleValueWidget("Pin Code", profile.pincode)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

// ignore: must_be_immutable
class _ParentInfo extends StatelessWidget {

  final UserProfile profile;

  _ParentInfo(this.profile,{Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _BuildTitleValueWidget("Distributor Name", profile.distributor_name),
                  _BuildTitleValueWidget("Distributor Mobile", profile.distributor_mobile),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}



