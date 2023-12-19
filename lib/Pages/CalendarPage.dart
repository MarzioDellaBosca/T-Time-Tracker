import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Center(
      child: Container(
        color: Colors.deepPurple.shade50,
        child: Column(
          children: [
            MyCalendar(),
            SizedBox(height: 30),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 180, // Imposta la larghezza desiderata
                      height: 80, // Imposta l'altezza desiderata
                      child: Card(
                        color: theme.colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Activities: ',
                            style: style,
                            semanticsLabel: 'Activities: ',
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyCalendar extends StatefulWidget {
  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final _events = {
    DateTime.now(): ['Event A', 'Event B'],
    DateTime.now().add(Duration(days: 1)): ['Event C'],
    DateTime.now().add(Duration(days: 3)): ['Event D', 'Event E', 'Event F'],
  };

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: Theme.of(context).textTheme.caption,
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
