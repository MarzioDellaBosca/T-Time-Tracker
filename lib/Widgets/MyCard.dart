import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double? temp;
  final double range;
  final String text;
  final TextStyle style;

  MyCard(
      {required this.temp,
      required this.range,
      required this.text,
      required this.style});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Card(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            height: MediaQuery.of(context).size.height / 4,
            width: width > range ? width / 4 : 230,
            margin: EdgeInsets.all(10),
            child: Center(
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: temp == null
                      ? SingleChildScrollView(child: Text(text, style: style))
                      : Column(
                          children: [
                            SizedBox(height: 20),
                            Text('$temp°C',
                                style: TextStyle(
                                    fontSize: 50,
                                    color:
                                        temp! > 20 ? Colors.red : Colors.blue,
                                    fontWeight: FontWeight.bold)),
                            Text(text, style: TextStyle(fontSize: 20)),
                          ],
                        )),
            )));
  }
}
