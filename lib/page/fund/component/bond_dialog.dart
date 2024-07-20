import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BondDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String data;

  const BondDialog(
      {Key? key,
      required this.data,
      required this.onAccept,
      required this.onReject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: WebView(
                    onWebViewCreated: (WebViewController controller) {
                      controller.loadHtmlString(data);
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: AppButton(text: "Accept", onClick: (){
                    Get.back();
                    onAccept();
                  })),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: AppButton(
                    text: "Reject",
                    onClick: (){
                      Get.back();
                      onReject();
                    },
                    background: Colors.red,
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
