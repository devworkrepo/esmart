import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:esmartbazaar/model/fund/request_report.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/app_util.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';
import 'package:esmartbazaar/widget/image.dart';



class ViewFundReceiptDialog extends StatefulWidget {
  final FundRequestReport report;
  const ViewFundReceiptDialog({required this.report,Key? key}) : super(key: key);


  @override
  _ViewFundReceiptDialogState createState() => _ViewFundReceiptDialogState();
}

class _ViewFundReceiptDialogState extends State<ViewFundReceiptDialog> {

  var downloadingText = "";

  downloadImage(String url) async {
    try {
      var dio = Dio();
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      var tempDir = await getTemporaryDirectory();
      String fullPath = tempDir.path + "/${widget.report.picName}'";

      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);

      OpenFile.open(fullPath,type: "image/*");
      await raf.close();
    } catch (e) {
      setState(() {
        downloadingText = "failed";
      });
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {

       setState(() {
         downloadingText =  (received / total * 100).toStringAsFixed(0) + "% Downloading...";
       });
       if(received == total){
         downloadingText= "Download completed";
       }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Receipt"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 24),
        child: Card(
          child: SizedBox(
            width: getx.Get.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
              Expanded(
                child: AppNetworkImage(
                  AppConstant.requestImageBaseUrl+widget.report.picName!,
                  size: getx.Get.width-200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(onPressed: (){
                  downloadImage(AppConstant.requestImageBaseUrl+widget.report.picName!);
                }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.download_rounded,),
                    SizedBox(width: 8,),
                    Text("Download")
                  ],)),
              ),
              Text(downloadingText),
              SizedBox(height: 16,),
            ],),
          ),
        ),
      ),
    );
  }
}
