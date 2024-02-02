import 'package:flutter/material.dart';

class MyInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int type;

  MyInputTextField(
      {required this.controller, required this.type, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: type == 1
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: label, helperStyle: TextStyle(color: Colors.grey)),
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            )
          : TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: UnderlineInputBorder(),
              ),
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
              minLines: 1,
              maxLines: 4,
            ),
    );
  }
}
