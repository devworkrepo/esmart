import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../util/app_util.dart';
import '../../widget/common.dart';

class DmtKycWebView extends StatefulWidget {
  const DmtKycWebView({Key? key}) : super(key: key);

  @override
  State<DmtKycWebView> createState() => _DmtKycWebViewState();
}

class _DmtKycWebViewState extends State<DmtKycWebView> {
  WebViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  _listJavaScriptEvents(String url) {
    AppUtil.logger(url);

    controller?.runJavascript("""
          document.getElementById("BtnSubmit").addEventListener("click",someFunction,false);
          function someFunction(event) {
                if(document.getElementById('BtnSubmit').value == 'Start Transactions')
                    TxnEvent.postMessage("true");
           }
      """);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var value = await controller?.runJavascriptReturningResult(
            "document.getElementById('BtnSubmit').value");
        value ??= "";
        if (value.replaceAll('"', '').toLowerCase() == "start transactions") {
          Get.back(result: {"isEkycCompleted": true});
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Ekyc"),
          ),
          body: WebView(
            onPageStarted: (string) {},
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
            },
            initialUrl: "https://esmartbazaar..in/testing/page1.aspx",
            onPageFinished: (url) {
              _listJavaScriptEvents(url);
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {
              JavascriptChannel(
                  name: 'TxnEvent',
                  onMessageReceived: (JavascriptMessage message) {
                    if (message.message == "true") {
                      Get.back(result: {"isEkycCompleted": true});
                    }
                  })
            },
          )),
    );
  }
}
