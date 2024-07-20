import 'package:esmartbazaar/util/app_util.dart';

class FormValidatorHelper {
  static String? normalValidation(value, {int minLength = 3}) {
    var msg = "Enter min $minLength characters";
    if (value == null) {
      return msg;
    } else {
      if (value.length >= minLength) {
        return null;
      } else {
        return msg;
      }
    }
  }
  static String? pincode(value) {
    var msg = "Enter 6 digits pincode";
    if (value == null) {
      return msg;
    } else {
      if (value.length == 6) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? passwordValidation(value) {
    var msg = "Enter min 6 characters password";
    if (value == null) {
      return msg;
    } else {
      if (value.length >= 6) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? emailValidation(value) {
    if (value == null) {
      return "Field can't be empty!";
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);

    if (emailValid) {
      return null;
    } else {
      return "Enter email with valid format";
    }
  }

  static String? otpValidation(value, {int digit = 4}) {
    var msg = "Enter $digit digits Otp";
    if (value == null) {
      return msg;
    } else {
      if (value.length == digit) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? mobileNumberValidation(value) {
    var msg = "Enter 10 digits mobile number";
    if (value == null) {
      return msg;
    } else {
      if (value.length == 10) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? amount(String? value,
      {int minAmount = 10, int maxAmount = 10000, int? multipleOf}) {
    bool checkMultipleOf() {
      if (multipleOf == null) return true;
      var doubleAmount = double.parse(value.toString());
      return doubleAmount % multipleOf == 0;
    }

    var msg = "Enter amount in range of $minAmount to $maxAmount";
    if (value == null) {
      return msg;
    } else if (maxAmount == -1) {
      try {
        var amount = double.parse(value);
        if (amount >= minAmount) {
          if(!checkMultipleOf()){
            return "Enter amount multiple of $multipleOf";
          }
          return null;
        } else {
          return "Minimum amount is $minAmount";
        }
      } catch (e) {
        AppUtil.logger(e.toString());
        return "Minimum amount is $minAmount";
      }
    } else {
      try {
        var amount = double.parse(value);
        if (amount >= minAmount && amount <= maxAmount) {
          if(!checkMultipleOf()){
            return "Enter amount multiple of $multipleOf";
          }
          return null;
        } else {
          return msg;
        }
      } catch (e) {
        AppUtil.logger(e.toString());
        return msg;
      }
    }
  }

  static String? empty(String? value,{String? message ="Field can't be empty!"} ) {

    if (value == null) {
      return message;
    } else {
      if (value.isNotEmpty) {
        return null;
      } else {
        return message;
      }
    }
  }

  static String? mpin(String? value, {int length = 4}) {
    var msg = "Enter $length digits MPIN";
    if (value == null) {
      return msg;
    } else {
      if (value.length == length) {
        return null;
      } else {
        return msg;
      }
    }
  }

 static  String? isValidPanCardNo(String? value) {
    var message = "Enter valid pan number";
    if(value == null) return message;
    final result =  RegExp(
        r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
        .hasMatch(value);

    if(result) {
      return null;
    } else {
      return message;
    }

  }

  static String? validateUpiId(String? upiId) {
    var message = "Enter valid upi id";
    if(upiId == null){
      return message;
    }
    final RegExp upiIdRegExp = RegExp(r'^[\w.-]+@[\w.-]+$');
    final result = upiIdRegExp.hasMatch(upiId);
    if (result) {
      return null;
    } else {
      return message;
    }
  }
}
