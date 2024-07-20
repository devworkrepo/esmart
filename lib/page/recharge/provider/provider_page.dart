import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/image.dart';
import 'package:esmartbazaar/widget/progress.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/model/recharge/provider.dart';
import 'package:esmartbazaar/page/exception_page.dart';
import 'package:esmartbazaar/page/main/home/home_controller.dart';
import 'package:esmartbazaar/page/recharge/provider/provider_controller.dart';
import 'package:esmartbazaar/util/hex_color.dart';

class ProviderPage extends GetView<ProviderController> {
  const ProviderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            "${getProviderInfo(controller.providerTypeObs.value)?.name ?? ""} Providers")),
      ),
      body: Container(

          padding: const EdgeInsets.all(8),
          height: Get.height,
          width: Get.width,
          child: Obx(() =>
              controller.providerResponseObs.value.when(onSuccess: (data) {
                return _buildBody();
              }, onFailure: (e) {
                return ExceptionPage(
                  error: e,
                );
              }, onInit: (data) {
                return AppProgressbar(
                  data: data,
                );
              }))),
    );
  }

  _buildBody() {
    return Column(
      children: [
        const Expanded(
          child: _BuildProviderList(),
        ),
        (controller.showBillType()) ?  Card(
            child: Obx(()=>Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _BuildBillServiceWidget(
                    title: "Electricity",
                    svgName: "electricity",
                    onClick: () {
                      controller.onBillTypeSelect(ProviderType.electricity);
                    },
                    isBig: controller.providerTypeObs.value ==
                        ProviderType.electricity,
                  ),
                  _BuildBillServiceWidget(
                    title: "Water",
                    svgName: "water",
                    onClick: () {
                      controller.onBillTypeSelect(ProviderType.water);
                    },
                    isBig:
                    controller.providerTypeObs.value == ProviderType.water,
                  ),
                  _BuildBillServiceWidget(
                    title: "Gas",
                    svgName: "gas",
                    onClick: () {
                      controller.onBillTypeSelect(ProviderType.gas);
                    },
                    isBig: controller.providerTypeObs.value == ProviderType.gas,
                  ),
                   _BuildBillServiceWidget(
                    title: "Landline",
                    svgName: "landline",
                    onClick: () {
                      controller.onBillTypeSelect(ProviderType.landline);
                    },
                    isBig: controller.providerTypeObs.value == ProviderType.landline,
                  ),
                ],
              ),
            ))) : const SizedBox()
      ],
    );
  }
}

class _BuildBillServiceWidget extends StatelessWidget {
  final String svgName;
  final String title;
  final VoidCallback onClick;
  final bool isBig;

  const _BuildBillServiceWidget(
      {Key? key,
      required this.title,
      required this.svgName,
      required this.onClick,
      required this.isBig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Opacity(
            opacity: (isBig) ? 1.0 : 0.8,
            child: SizedBox(
              height: (isBig) ? 60 : 45,
              width: 220,
              child:AppCircleAssetSvg(
              "assets/svg/${svgName}.svg",
              backgroundColor: HexColor("91d2ed"),
            ),),
          ),
          Text(
            title,
            style: Get.textTheme.bodyText1?.copyWith(
                color: (isBig) ? Get.theme.primaryColorDark : Colors.grey,
                fontWeight: (isBig) ? FontWeight.w600 : FontWeight.w400),
          )
        ],
      ),
    ));
  }
}

class _BuildProviderList extends GetView<ProviderController> {
  const _BuildProviderList();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          (controller.showSearchOption()) ? AppSearchField(
            onChange: controller.onSearchChange,
          ) : const SizedBox(),
          Expanded(
            child: Obx(() {
              var item = controller.searchProviderListObs.length;

              return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: item,
                  itemBuilder: (context, index) {
                    return _BuildItem(
                      controller.searchProviderListObs[index],
                      key: Key(controller.searchProviderListObs[index].id
                          .toString()),
                    );
                  });
            }),
          )
        ],
      ),
    );
  }
}

class _BuildItem extends GetView<ProviderController> {
  final Provider provider;

  const _BuildItem(this.provider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => controller.onItemClick(provider),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Opacity(
                opacity: 0.7,
                child: AppCircleAssetSvg(
                    "assets/svg/${getProviderInfo(controller.providerType)?.imageName ?? ""}.svg"),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  provider.name,
                  style: Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const Divider(
            height: 20,
          ),
        ],
      ),
    );
  }
}
