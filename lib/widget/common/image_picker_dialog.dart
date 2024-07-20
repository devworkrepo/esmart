import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerSourceWidget extends StatelessWidget {

  final Function(ImageSource) onSelect;

  const ImagePickerSourceWidget({Key? key,required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(16),
      height: 160,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("Select Image Source", style: Get.textTheme.headline4,),
          const SizedBox(height: 16,),
          Expanded(
            child: Row(children: [
              Expanded(child: GestureDetector(
                onTap: (){
                  Get.back();
                  onSelect(ImageSource.gallery);
                },
                child: const _PickItem(
                  icon: Icons.image_rounded,
                  title: "Gallery",
                ),
              )),
              Expanded(child: GestureDetector(
                onTap: (){
                  Get.back();
                  onSelect(ImageSource.camera);
                },
                child: const _PickItem(
                  icon: Icons.camera,
                  title: "Camera",
                ),
              )),
            ],),
          )
        ],
      ),

    );
  }
}


class _PickItem extends StatelessWidget {

  final IconData icon;

  final String title;

  const _PickItem({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Icon(icon, size: 60,)),
        Text(title, style: Get.textTheme.subtitle1,)
      ],
    );
  }
}

