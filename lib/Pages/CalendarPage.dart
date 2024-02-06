import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Widgets/ActivityDescription.dart';
import 'package:flutter_tracker_application/Widgets/ActivityListView.dart';
import 'package:flutter_tracker_application/Widgets/Calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final List<Activity> activities;
  final imgProvider;
  CalendarPage({required this.activities, required this.imgProvider});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Activity> get activities => widget.activities;
  ImgProvider get imgProvider => widget.imgProvider;
  DateTime? _selectedDay;
  Activity? selectedActivity;

  List<Activity> _activitiesForSelectedDay() {
    List<Activity> ret = activities.where((activity) {
      return DateFormat('dd/MM/yy').parse(activity.getDate()).day ==
              _selectedDay?.day &&
          DateFormat('dd/MM/yy').parse(activity.getDate()).month ==
              _selectedDay?.month &&
          DateFormat('dd/MM/yy').parse(activity.getDate()).year ==
              _selectedDay?.year;
    }).toList();
    return ret;
  }

  void selectActivity(Activity activity) {
    setState(() {
      selectedActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imgProvider
                .imgPath), // sostituisci con il tuo percorso di immagine
            fit: BoxFit.cover,
          ),
        ),
        child: width <= 600
            ? Container()
            : Column(
                children: [
                  height <= 500
                      ? Container()
                      : MyCalendar(
                          onDaySelected: (selectedDay) {
                            setState(() {
                              if (selectedDay != _selectedDay) {
                                selectedActivity = null;
                              }
                              _selectedDay = selectedDay;
                            });
                          },
                          activities: activities),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height <= 650
                          ? Container()
                          : Column(
                              children: [
                                Container(
                                  height: 40,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 50,
                                      width: 130,
                                      child: Center(
                                        child: Text(
                                          "Activities:",
                                          style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontSize:
                                                24, // Imposta la dimensione del font
                                            fontWeight: FontWeight
                                                .bold, // Imposta il peso del font
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 400,
                                    height:
                                        180, // Imposta la larghezza desiderata
                                    child: ActivityListView(
                                      activities: _activitiesForSelectedDay(),
                                      selectActivity: selectActivity,
                                    )),
                              ],
                            ),
                      SizedBox(width: 30),
                      Container(
                        child: selectedActivity != null
                            ? ActivityDescription(activity: selectedActivity!)
                            : null,
                      )
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
