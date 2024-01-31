import 'package:flutter/material.dart';

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
          image: AssetImage(imgProvider
              .imgPath), // sostituisci con il tuo percorso di immagine
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
                Card(
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
                          child: Text(
                              'In the activities section you will be able to create, modify, and delete activities that will be added to your personal calendar.',
                              style: style),
                        )))),
                Card(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height / 4,
                        width: MediaQuery.of(context).size.width / 4,
                        margin: EdgeInsets.all(10),
                        child: Center(
                            child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                    'In the statistics section, you will find information regarding the distribution of the types of activities you perform over time, representing a valuable tool for getting to know yourself better!',
                                    style: style))))),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
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
                          child: Text(
                              'In the calendar, you will be able to see on which days you have activities to do and to check what they refer to!',
                              style: style),
                        )))),
                Card(
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
                                child: Text(
                                    'In the settings section, you will be able to modify your username and password. Additionally, you can change the theme of the entire application!',
                                    style: style))))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
