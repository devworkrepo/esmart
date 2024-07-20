import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:esmartbazaar/util/file_util.dart';
import 'package:esmartbazaar/util/image_util.dart';
import 'package:esmartbazaar/widget/common/image_picker_dialog.dart';
import 'package:esmartbazaar/widget/dialog/status_dialog.dart';

class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static pickImageWithCrop(Function(File?) onPick, Function? onPickClick) {
    Get.bottomSheet(ImagePickerSourceWidget(
      onSelect: (ImageSource source) async {
        if (onPickClick != null) onPickClick();
        File? file = await _pickAndCrop(source);
        onPick(file);
      },
    ));
  }

  static Future<File?> _pickAndCrop(ImageSource source) async {
    XFile? image = await _imagePicker.pickImage(source: source);
    if (image == null) {
      var sourceInString = (source == ImageSource.gallery)
          ? "Failed to pick image from Gallery"
          : "Failed to take image from camera";

      Get.snackbar("Please try again", sourceInString,
          backgroundColor: Colors.red, colorText: Colors.white);

      return null;
    } else {
      StatusDialog.progress();

      var fileExtension = path.extension(image.path);
      File rotateFile = await compute(ImageUtil.fixRotation, image.path);

      String newFilePath = await FileUtil.getTempFile(extension: fileExtension);
      File file = await compute(ImageUtil.resizeImage, {"filePath": newFilePath, "file": rotateFile});

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      return file;
    }
  }
}
