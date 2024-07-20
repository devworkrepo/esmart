import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';



class FileUtil{

  FileUtil._();

  static Future<double> getFileSizeInKb(String? filePath) async {
    if(filePath == null) return 0.0;
    var sizeInB =  File(filePath).lengthSync();
    var sizeInKB = sizeInB / 1024;
    return sizeInKB;
  }

  static Future<String> getTempFile({String? extension}) async{
    var dir = await getTemporaryDirectory();
    if(extension == null) {
      return dir.path;
    } else {
      return path.join((dir).path,
    "${DateTime.now()}.$extension");
    }
  }
}