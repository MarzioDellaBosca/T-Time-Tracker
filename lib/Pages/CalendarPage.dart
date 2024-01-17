import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  final List<Activity> activities;
  CalendarPage({required this.activities});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Activity> get activities => widget.activities;
  DateTime? _selectedDay;
  Activity? selectedActivity;

  List<Activity> _activitiesForSelectedDay() {
    return activities.where((activity) {
      return DateFormat('dd/MM/yy').parse(activity.getDate()).day ==
              _selectedDay?.day &&
          DateFormat('dd/MM/yy').parse(activity.getDate()) ==
              _selectedDay?.month &&
          DateFormat('dd/MM/yy').parse(activity.getDate()) ==
              _selectedDay?.year;
    }).toList();
  }

  void selectActivity(Activity activity) {
    setState(() {
      selectedActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activitiesForSelectedDay = _activitiesForSelectedDay();
    //final theme = Theme.of(context);
    /*final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );*/
    return Center(
      child: Container(
        color: Colors.deepPurple.shade50,
        child: Column(
          children: [
            MyCalendar(
              activities: activities,
              onDaySelected: (selectedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
            ),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 30),
                Column(
                  children: [
                    Container(
                      width: 180, // Imposta la larghezza desiderata
                      height: 80, // Imposta l'altezza desiderata
                      child: Text(
                        "Activities:",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 24, // Imposta la dimensione del font
                          fontWeight:
                              FontWeight.bold, // Imposta il peso del font
                        ),
                      ),
                    ),
                    /* Expanded(
                      child: ListView.builder(
                        itemCount: activitiesForSelectedDay.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(activitiesForSelectedDay[index]
                                      .getTitle()), // Titolo a sinistra
                                  Text(activitiesForSelectedDay[index]
                                      .getDate()), // Data a destra
                                ],
                              ),
                              onTap: () {
                                selectActivity(activitiesForSelectedDay[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),*/
                  ],
                ),
                SizedBox(width: 30)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyCalendar extends StatefulWidget {
  final List<Activity> activities;
  final ValueChanged<DateTime> onDaySelected;
  MyCalendar({required this.onDaySelected, required this.activities});

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  List<Activity> get activities => widget.activities;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<String>> _events = {};

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });

    if (_selectedDay != null) {
      widget.onDaySelected(_selectedDay!);
    }
  }

  @override
  Widget build(BuildContext context) {
    for (var activity in activities) {
      DateTime date = DateFormat('dd/MM/yy').parse(activity.getDate());
      date = DateTime(date.year, date.month, date.day);
      if (_events[date] == null) {
        _events[date] = [activity.getTitle()];
      } else {
        _events[date]!.add(activity.getTitle());
      }
    }
    //print(_events);

    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          date = DateTime(date.year, date.month, date.day);
          var todayEvents = _events[date] ?? [];
          return Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 30,
                    //alignment: Alignment.center,
                    child: date.day.toString().length == 1
                        ? Text(
                            '  ${date.day}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: todayEvents.isNotEmpty
                                          ? Colors.transparent
                                          : Colors.black,
                                    ),
                          )
                        : Text(
                            ' ${date.day}',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: todayEvents.isNotEmpty
                                          ? Colors.transparent
                                          : Colors.black,
                                    ),
                          ),
                  ),
                  if (todayEvents.isNotEmpty)
                    Positioned(
                      bottom: 0, // Posiziona l'icona in basso
                      child: Opacity(
                        opacity: 0.7, // Imposta l'opacità al 50%
                        child: Icon(
                          Icons.star,
                          size: 25, // Mostra un'icona se ci sono eventi
                          color:
                              Colors.deepPurple, // Cambia il colore dell'icona
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        selectedBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(2.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.deepPurple, // Imposta il colore desiderato
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                    color: Colors.white), // Imposta il colore del testo
              ),
            ),
          );
        },
        singleMarkerBuilder: (context, date, event) {
          return event != null ? Icon(Icons.star, size: 16.0) : null;
        },
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
