import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class DigitalClock extends StatefulWidget {
  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  String getSystemTime() {
    var now = new DateTime.now();
    return DateFormat("H:mm").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(Duration(seconds: 10), builder: (context) {
      return Text(
        "${getSystemTime()}",
        style: TextStyle(
            color: Color(0xff2d386b),
            fontSize: 30,
            fontWeight: FontWeight.w700),
      );
    });
  }
}
