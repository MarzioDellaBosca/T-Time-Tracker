import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Widgets/MyCard.dart';

class HelpPage extends StatelessWidget {
  final imgProvider;
  HelpPage({required this.imgProvider});
  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
        color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.w600);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgProvider.imgPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyCard(
                    temp: null,
                    range: 1000,
                    text:
                        'In the activities section you will be able to create, modify, and delete activities that will be added to your personal calendar.\n\nDon\'t forget to log out after you have finished your activities or they\'ll be missed!',
                    style: style),
                MyCard(
                    temp: null,
                    range: 1000,
                    text:
                        'In the statistics section, you will find information regarding the distribution of the types of activities you perform over time, representing a valuable tool for getting to know yourself better!',
                    style: style),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyCard(
                    temp: null,
                    range: 1000,
                    text:
                        'In the calendar, you will be able to see on which days you have activities to do and to check what they refer to!',
                    style: style),
                MyCard(
                    temp: null,
                    range: 1000,
                    text:
                        'In the settings section, you will be able to modify your username and password. Additionally, you can change the theme of the entire application!',
                    style: style),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
