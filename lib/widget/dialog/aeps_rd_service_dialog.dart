import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/drop_down.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/data/app_pref.dart';
import 'package:esmartbazaar/util/mixin/dialog_helper_mixin.dart';

class AepsRdServiceDialog extends StatelessWidget with DialogHelperMixin {
  AppPreference appPreference = Get.find();

  final Function(String) onClick;

  late String selectRdService ;

  var mantraPackage = "com.mantra.rdservice";
  var morphoPackage = "com.scl.rdservice";
  var startekPackage = "com.acpl.registersdk";
  var secuGenPackage = "com.secugen.rdservice";

  AepsRdServiceDialog({required this.onClick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    selectRdService = _getRdService();

    return buildBaseContainer(
        title: "Select RD Service",
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const AppCircleAssetImage(
                  "assets/image/ic_aeps.png",
                  horizontalPadding: 0,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: AppDropDown(
                    hideLabel: true,
                    list: const ["MORPHO", "MANTRA", "STARTEK","SecuGen"],
                    onChange: (v) {
                      selectRdService = v;
                    },
                    label: "RD Service",
                    hint: "Select RD Service",
                    selectedItem: selectRdService,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            AppButton(text: "Proceed", onClick: () async{
             await appPreference.setRdService(selectRdService);

             String rdServicePackageUrl;

             if(selectRdService == "MORPHO"){
              rdServicePackageUrl = morphoPackage;
             }
             else if (selectRdService == "MANTRA"){
               rdServicePackageUrl = mantraPackage;
             }
             else if (selectRdService == "SecuGen"){
               rdServicePackageUrl = secuGenPackage;
             }
             else {
               rdServicePackageUrl = startekPackage;
             }

             Get.back();
             onClick(rdServicePackageUrl);
            })
          ],
        ));
  }

  _getRdService() {
    var rdService = appPreference.rdService;
    if (rdService.isEmpty) {
      return "MORPHO";
    } else {
      return rdService;
    }
  }
}
