import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackgroundImageWidget extends StatelessWidget {
  final Widget child;
  final String imageName;

  const BackgroundImageWidget(
      {required this.child, required this.imageName, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [_buildBackground(), child],
    );
  }

  _buildBackground() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.black12, Colors.black38],
              begin: Alignment.center,
              end: Alignment.bottomCenter)
          .createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/image/" + imageName,
                ),
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.darken))),
      ),
    );
  }
}
