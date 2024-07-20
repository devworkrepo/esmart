import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'matm_process_controller.dart';

class MatmInProcessPage extends GetView<MatmProcessController> {
  const MatmInProcessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmProcessController());
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                      width: 140,
                      height: 60,
                      child: Image.asset("assets/image/logo.png")),
                  const SizedBox(
                    height: 16,
                  ),
                  _ProgressWidget(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Please wait, while we are processing your micro atm transaction",
                      style: Get.textTheme.headline6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Processing Transaction...",
                              style: Get.textTheme.headline6,
                            ),
                            Text(
                              "Please wait",
                              style: Get.textTheme.subtitle1,
                            )
                          ],
                        )),
                        Stack(
                          clipBehavior: Clip.antiAlias,
                          fit: StackFit.loose,
                          children: [
                            const SizedBox(
                                height: 45,
                                width: 45,
                                child: CircularProgressIndicator()),
                            Positioned(
                              top: 5,
                              left: 5,
                              right: 5,
                              bottom: 5,
                              child: SizedBox(
                                width: 30,
                                child: SvgPicture.asset(
                                  "assets/svg/matm.svg",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _ProgressWidget extends GetView<MatmProcessController> {
  _ProgressWidget({Key? key}) : super(key: key);

  var TWO_PI = 3.14 * 2;

  @override
  Widget build(BuildContext context) {
    const size = 80.0;
    return Center(
      // This Tween Animation Builder is Just For Demonstration, Do not use this AS-IS in Projects
      // Create and Animation Controller and Control the animation that way.
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 60),
        onEnd: () {
          controller.onTimerEnd();
        },
        builder: (context, double value, child) {
          int percentage = 60 - (value * 60).ceil();
          return Container(
            width: size,
            height: size,
            child: Stack(
              children: [
                ShaderMask(
                  shaderCallback: (rect) {
                    return SweepGradient(
                            startAngle: 0.0,
                            endAngle: TWO_PI,
                            stops: [value, value],
                            // 0.0 , 0.5 , 0.5 , 1.0
                            center: Alignment.center,
                            colors: [Colors.blue, Colors.grey.withAlpha(55)])
                        .createShader(rect);
                  },
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: Image.asset("assets/image/radial_scale.png")
                                .image)),
                  ),
                ),
                Center(
                  child: Container(
                    width: size - 40,
                    height: size - 40,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      "$percentage",
                      style: TextStyle(fontSize: 24),
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
