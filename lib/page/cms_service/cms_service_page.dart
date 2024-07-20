import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/model/cms_service.dart';
import 'package:esmartbazaar/util/obx_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../util/validator.dart';
import '../../widget/button.dart';
import '../../widget/text_field.dart';
import 'cms_service_controller.dart';

class CMSServicePage extends GetView<CMSServiceController> {
  const CMSServicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CMSServiceController());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CMS Service"),
        ),
        body: ObsResourceWidget<CmsServiceResponse>(
            obs: controller.cmsServiceResponseObs,
            childBuilder: (data) => (controller.redirectUrl.value == "")
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(48),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/image/cms_service.png",
                              height: 80,
                              width: 80,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Pay your outstanding CMS payment easily with us",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.primaryColorLight),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  controller
                                      .onProceed(data.redirecturl.toString());
                                },
                                child: const Text("Start Payment"))
                          ],
                        ),
                      ),
                    ),
                  )
                : _webViewWidget()),
      ),
    );
  }

  _webViewWidget() {
    return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onPageStarted: (url) {},
        onWebViewCreated: (WebViewController webViewController) {
          controller.webViewController = webViewController;
        },
        initialUrl: controller.redirectUrl.value,
        onPageFinished: (url) {});
  }
}
