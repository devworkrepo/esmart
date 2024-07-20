import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int durationSecond;
  final VoidCallback onTimerComplete;

  const CounterWidget(
      {Key? key, this.durationSecond =kDebugMode ? 5 : 60, required this.onTimerComplete})
      : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late Timer timer;
  late int startValue;

  @override
  void initState() {
    super.initState();
    startValue = widget.durationSecond;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (startValue == 0) {
        setState(() {
          timer.cancel();
          widget.onTimerComplete();
        });
      } else {
        setState(() {
          startValue--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Column(
          children: [
            Text(
              startValue.toString(),
              style: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 8,),
             Text("Please wait for ${widget.durationSecond} seconds for resend otp",textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

