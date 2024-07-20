import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/common.dart';
import 'package:esmartbazaar/service/location.dart';
import 'package:esmartbazaar/util/mixin/location_helper_mixin.dart';

mixin TransactionHelperMixin {

  CancelToken? cancelToken;

   bool checkBalance(String? walletAmount,String amount) {

     if(kDebugMode) return true;

    var title = "Wallet Balance";
    var msg = "unable to fetch you balance, please logout and try again!";
    if (walletAmount == null) {
      _showSnackbar(title, msg);
      return false;
    } else {
      if (walletAmount.isEmpty) {
        _showSnackbar(title, msg);
        return false;
      } else {
        try {
          var doubleAmount = double.parse(walletAmount);
          if (doubleAmount < double.parse(amount)) {
            _showSnackbar("Insufficient wallet balance!",
                "current balance is : $walletAmount",
                background: Colors.yellow[900]!);
            return false;
          } else {
            return true;
          }
        } catch (e) {
          _showSnackbar(title, msg);
          return false;
        }
      }
    }
  }


  String amountWithoutRupeeSymbol(TextEditingController amountController){

     var text = amountController.text.toString();
     if(text.isNotEmpty && text.startsWith("₹ ")){
       return text.substring(2);
     }
     else {
       return text;
     }

  }

   String aadhaarWithoutSymbol(TextEditingController aadhaarController){

     var text = aadhaarController.text.toString();
     if(text.isNotEmpty){
       return text.replaceAll("-","");
     }
     else {
       return text;
     }

   }


   _showSnackbar(String title, String message,
      {Color background = Colors.red, Color color = Colors.white}) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: background,
        colorText: color);
  }


}