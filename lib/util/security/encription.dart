import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:esmartbazaar/util/app_util.dart';

import 'app_config.dart';

class Encryption {

  Encryption._();
  
  
  static String encryptCredopPayPassword(String valueToBeDecrypted) {
    final key = Key.fromUtf8("62f3add5c2d74dcfa7d865a3aae6db25");
   // final iv = IV.fromUtf8("62f3add5c2d74dcfa7d865a3aae6db25");
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));

    Uint8List ivData = Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0]);
    var iv = IV(ivData);
    var data = encrypter.decrypt(Encrypted.fromBase64(valueToBeDecrypted),iv: iv);
    AppUtil.logger("Decrypted credopay data : $data");
    return data;
  }

  static String encryptMPIN(String text){
    return text;
    if(text.isEmpty || text == "na"){
      return text;
    }
    return aesEncrypt(text);
  }

  static Future<String> getEncValue(String mobileNumber) async{
    final String deviceId = await AppUtil.getDeviceID();
    return aesEncrypt(deviceId+"_"+ deviceId+"_"+mobileNumber);
  }

  static String aesEncrypt(String valueToBeEncrypted) {
    final key = Key.fromUtf8(AppConfig.networkKey);
    final iv = IV.fromUtf8(AppConfig.networkKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    var encrypted = encrypter.encrypt(valueToBeEncrypted, iv: iv);
    var data =  encrypted.base64;
    AppUtil.logger("Encrypted data : $data");
    aepDecrypt(data);
    return data;
  }

  static String aepDecrypt(String valueToBeDecrypted) {
    final key = Key.fromUtf8(AppConfig.networkKey);
    final iv = IV.fromUtf8(AppConfig.networkKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    var data = encrypter.decrypt(Encrypted.fromBase64(valueToBeDecrypted), iv: iv);
    AppUtil.logger("Decrypted data : $data");
    return data;
  }
}
