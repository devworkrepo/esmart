import 'package:esmartbazaar/model/qr_code/qrcod.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../util/obx_widget.dart';
import 'my_qr_controller.dart';

class MyQRCodePage extends GetView<MyQRCodeController> {
  const MyQRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyQRCodeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("My QR Codes"),
      ),
      body:  ObsResourceWidget(
        obs: controller.reportResponseObs,
        childBuilder:(data)=> _buildBody(data.qrCodes!),
      ) ,
    );
  }

  _buildBody(List<QRCode> qrCodes) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: qrCodes.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context,index)=> Container(
        width: MediaQuery.of(context).size.width-48,
        padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 100),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      padding : EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      
                     child:(qrCodes[index].upi_pic ==null || qrCodes[index].upi_pic!.isEmpty) ? QrImageView(
                       data: qrCodes[index].upi_url!.toString(),
                       version: QrVersions.auto,
                       size: 320,
                       gapless: true,
                       embeddedImageStyle: const QrEmbeddedImageStyle(
                         size: Size(40, 40),

                       ),
                       eyeStyle: QrEyeStyle(
                           eyeShape: QrEyeShape.square,
                           color: Get.theme.primaryColor
                       ),
                     ) :  Padding(
                       padding: const EdgeInsets.all(24.0),
                       child: Image.network(AppConstant.qrCodeBaseUrl + qrCodes[index].upi_pic.toString(),height: 320,width: 320,fit: BoxFit.fill,),
                     ),

                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(5),
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/icon/sb.png'),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 5,),
              Text(
                qrCodes[index].upi_id.toString(),
                style: Get.textTheme.subtitle1
                    ?.copyWith(color:Colors.grey,fontWeight: FontWeight.w400,fontSize: 14),
              ),
              const SizedBox(
                height: 12,
              ),

              // SizedBox(
              //   width: 150,
              //   child: OutlinedButton(
              //       onPressed: () {
              //         Get.find<HomeRepoImpl>().downloadFileAndSaveToGallery(
              //             AppConstant.qrCodeBaseUrl, "demo"!);
              //       },
              //       child: const Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //         Icon(Icons.download),
              //         Text("Download")
              //       ],),),
              // ),

            ],
          ),
        ),
      ),

    );
  }

}
