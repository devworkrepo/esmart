import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esmartbazaar/util/app_util.dart';

class AadhaarInputValidator extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('-');
      }
    }

    var string = buffer.toString();

    AppUtil.logger("hello dev : $string");

    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length)
    );
  }
}



class AmountInputValidator extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if(!text.startsWith("₹ ")){
      return newValue.copyWith(
          text:"₹ "+ text,
          selection: TextSelection.collapsed(offset: text.length+2)
      );
    }
    return newValue;
  }
}
