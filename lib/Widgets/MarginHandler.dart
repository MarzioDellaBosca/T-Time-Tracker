import 'package:flutter/material.dart';

class MarginHandler extends StatelessWidget {
  final List<Widget> children;
  final double widthRange;

  MarginHandler({required this.children, required this.widthRange});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= widthRange
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
  }
}
