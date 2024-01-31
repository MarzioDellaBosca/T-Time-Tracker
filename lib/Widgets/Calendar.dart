import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class MyCalendar extends StatefulWidget {
  final List<Activity> activities;

  final Function(DateTime) onDaySelected;

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
              color: Colors.deepPurple[50], // Imposta il colore desiderato
              border: Border.all(color: Colors.blueGrey),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 30,
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
                          color: Colors
                              .blue.shade900, // Cambia il colore dell'icona
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
        widget.onDaySelected(selectedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
