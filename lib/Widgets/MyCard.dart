import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final String text;
  final TextStyle style;

  MyCard({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 4,
            margin: EdgeInsets.all(10),
            child: Center(
                child: Container(
              margin: EdgeInsets.all(10),
              child: Text(text, style: style),
            ))));
  }
}
