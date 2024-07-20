class CashConverter {
  CashConverter._();

  static const _units = [
    "",
    " one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen"
  ];

  static const _tens = [
    "", // 0
    "", // 1
    "twenty", // 2
    "thirty", // 3
    "forty", // 4
    "fifty", // 5
    "sixty", // 6
    "seventy", // 7
    "eighty", // 8
    "ninety" // 9
  ];

  static String doubleConvert(double n) {
    var pass = n.toString() + "";
    var token = pass.split(".");
    var first = token.first;
    var last = token.last;
    try {
      pass = _convert(int.parse(first)) + " ";
      pass += "rupees and";

      for (int i = 0; i < last.length; i++) {
        var get = _convert(int.parse((last[i].toString() + "")));
        pass = (get.isEmpty) ? "$pass zero" : "$pass $get";
      }
    } catch (e) {}
    return pass;
  }

  static String _convert(int n) {
    if (n < 0) {
      return "minus " + _convert(-n);
    }
    if (n < 20) {
      return _units[n];
    }
    if (n < 100) {
      return _tens[n ~/ 10] + ((n % 10 != 0) ? " " : "") + _units[n % 10];
    }
    if (n < 1000) {
      return _units[n ~/ 100] +
          " hundred " +
          ((n % 100 != 0) ? " " : "") +
          _convert(n % 100);
    }
    if (n < 100000) {
      return _convert(n ~/ 1000) +
          " thousand " +
          ((n % 1000 != 0) ? " " : "") +
          _convert(n % 1000);
    }

    return (n < 10000000)
        ? _convert(n ~/ 100000) +
            " crore " +
            ((n % 100000 != 0) ? " " : "") +
            _convert(n % 100000)
        : "";
  }
}
