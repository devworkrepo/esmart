import 'dart:async' show Future;
import 'dart:io' show File;
import 'package:image/image.dart' as Im;

class ImageUtil {
  ImageUtil._();

  static Future<File> resizeImage(Map<String,dynamic> map) async {

    File file = map["file"];
    String newFilePath = map["filePath"];

    Im.Image image = Im.decodeImage(file.readAsBytesSync())!;
    Im.Image smallerImage = Im.copyResize(image, height: 1260);
    return  await decodeImageFile(smallerImage,newFilePath);
  }

  static Future<File> decodeImageFile(Im.Image image, String newFilePath) async {
    File decodedImageFile = File(newFilePath);
    decodedImageFile.writeAsBytesSync(Im.encodeJpg(image, quality: 85));
    return decodedImageFile;
  }

  static Future<File> fixRotation(String filePath) async {
    final Im.Image? capturedImage =
        Im.decodeImage(await File(filePath).readAsBytes());
    final Im.Image orientedImage = Im.bakeOrientation(capturedImage!);
    return await File(filePath).writeAsBytes(Im.encodeJpg(orientedImage));
  }
}
