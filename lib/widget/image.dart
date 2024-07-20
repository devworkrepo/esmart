import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/res/color.dart';
import 'package:esmartbazaar/util/hex_color.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const AppNetworkImage(this.imageUrl, {this.size = 80, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) {
        return Stack(
          children: [
            Center(
                child: Icon(
              Icons.image_search,
              size: (size - 8).toDouble(),
              color: Colors.black45,
            )),
            const Center(
                child: CircularProgressIndicator(
              color: Colors.black45,
            ))
          ],
        );
      },
      errorWidget: (context, url, error) {
        return Icon(
          Icons.image_not_supported_outlined,
          size: (size - 8).toDouble(),
        );
      },
      height: size.toDouble(),
      width: size.toDouble(),
    );
  }
}

class AppCircleNetworkImage extends StatelessWidget {
  final String imageUrl;
  final int horizontalPadding;
  final int size;

  const AppCircleNetworkImage(this.imageUrl,
      {this.horizontalPadding = 12, this.size = 50, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: size.toDouble(),
        width: size.toDouble(),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context,url){
           // return Icon(Icons.image_outlined,size: (size-8).toDouble(),);

            return Stack(children: [
              Center(child: Icon(Icons.image_search,size: (size-8).toDouble(),color: Colors.black45,)),
              Center(

                  child: CircularProgressIndicator(color: Colors.black45,))

            ],);
          },
          errorWidget:(context,url,error){
            return Icon(Icons.image_not_supported_outlined,size: (size-8).toDouble(),);
          },
          height: size.toDouble(),
          width: size.toDouble(),
        ),
      )
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      padding: const EdgeInsets.all(4),
      decoration:
      BoxDecoration(color: HexColor("ECF8FD"), shape: BoxShape.circle),
      child: Image.network(
        imageUrl,
        height: size.toDouble(),
        width: size.toDouble(),
      ),
    );
  }
}


class AppCircleAssetImage extends StatelessWidget {
  final String imagePath;
  final int horizontalPadding;

  const AppCircleAssetImage(this.imagePath, {this.horizontalPadding = 12,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      padding: const EdgeInsets.all(4),
      decoration:
      BoxDecoration(color: HexColor("fff6f5"), shape: BoxShape.circle),
      child: Image.asset(
        imagePath,
        color: Get.theme.primaryColorDark,
        height: 50,
        width: 50,
      ),
    );
  }
}


class AppCircleAssetSvg extends StatelessWidget {
  final String imagePath;
  final int horizontalPadding;
  final Color? backgroundColor;
  final int size;
  final int innerPadding ;

  const AppCircleAssetSvg(this.imagePath,
      {this.horizontalPadding = 12, Key? key, this.backgroundColor,this.size = 50,this.innerPadding = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.toDouble(),
      width: size.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      decoration:
      BoxDecoration(color: backgroundColor ?? HexColor("E0F6FF"), shape: BoxShape.circle),
      child: Padding(
        padding:  EdgeInsets.all(innerPadding.toDouble()),
        child: SvgPicture.asset(
          imagePath,
        ),
      ),
    );
  }
}
class AppCircleAssetPng extends StatelessWidget {
  final String imagePath;
  final int horizontalPadding;
  final Color? backgroundColor;
  final int size;
  final int innerPadding ;

  const AppCircleAssetPng(this.imagePath,
      {this.horizontalPadding = 12, Key? key, this.backgroundColor,this.size = 50,this.innerPadding = 4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.toDouble(),
      width: size.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      decoration:
      BoxDecoration(color: backgroundColor ?? HexColor("E0F6FF"), shape: BoxShape.circle),
      child: Padding(
        padding:  EdgeInsets.all(innerPadding.toDouble()),
        child: Image.asset(
          imagePath,
        ),
      ),
    );
  }
}
