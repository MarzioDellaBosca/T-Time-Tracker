import 'package:flutter/material.dart';

class MarginHandler extends StatelessWidget {
  final List<Widget> children;
  final double widthRange;
  final double heightRange;

  MarginHandler(
      {required this.children,
      required this.widthRange,
      required this.heightRange});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return width >= widthRange
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: height <= heightRange / 2 ? [Container()] : children,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: height <= heightRange ? [Container()] : children,
          );
  }
}
