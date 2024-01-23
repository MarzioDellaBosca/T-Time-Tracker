import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  final List<Activity> activities;
  StatisticsPage({required this.activities});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Activity> get activities => widget.activities;

  List<Activity> _seriesForOtherCat = [];
  List<Activity> _seriesForSportCat = [];
  List<Activity> _seriesForStudyCat = [];
  List<Activity> _seriesForWorkCat = [];

  double _hoursForOtherCat = 0;
  double _hoursForSportCat = 0;
  double _hoursForStudyCat = 0;
  double _hoursForWorkCat = 0;

  double _totHours = 1;

  @override
  void initState() {
    super.initState();
    _seriesForOtherCat = _createSeriesForCategory('Other', 0, 'default');
    _seriesForSportCat = _createSeriesForCategory('Sport', 0, 'default');
    _seriesForStudyCat = _createSeriesForCategory('Study', 0, 'default');
    _seriesForWorkCat = _createSeriesForCategory('Work', 0, 'default');

    _hoursForOtherCat = _seriesForOtherCat.isNotEmpty
        ? _seriesForOtherCat
            .map((activity) => activity.getDuration().toDouble())
            .reduce((a, b) => a + b)
        : 0;
    _hoursForSportCat = _seriesForSportCat.isNotEmpty
        ? _seriesForSportCat
            .map((activity) => activity.getDuration().toDouble())
            .reduce((a, b) => a + b)
        : 0;
    _hoursForStudyCat = _seriesForStudyCat.isNotEmpty
        ? _seriesForStudyCat
            .map((activity) => activity.getDuration().toDouble())
            .reduce((a, b) => a + b)
        : 0;
    _hoursForWorkCat = _seriesForWorkCat.isNotEmpty
        ? _seriesForWorkCat
            .map((activity) => activity.getDuration().toDouble())
            .reduce((a, b) => a + b)
        : 0;

    _totHours = _hoursForOtherCat +
                _hoursForSportCat +
                _hoursForStudyCat +
                _hoursForWorkCat >
            0
        ? _hoursForOtherCat +
            _hoursForSportCat +
            _hoursForStudyCat +
            _hoursForWorkCat
        : 1;
  }

  List<Activity> _createSeriesForCategory(
      String category, int ctrl, String date) {
    return [
      for (var activity in activities)
        if (ctrl == 0)
          if (activity.getCategory() == category)
            activity
          else if (ctrl == 1)
            if (activity.getCategory() == category &&
                activity.getDate() == date)
              activity
    ];
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
            child: Text(
          'Total Activities stats:',
          style: TextStyle(
              fontSize: 30,
              color: Colors.blue, // Cambia il colore del testo
              fontWeight: FontWeight.bold),
        )),
        Container(
          width: 500,
          child: Card(
            child: Column(
              children: [
                // Legenda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8), // Spazio tra il box e il testo
                    Text('Other'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8), // Spazio tra il box e il testo
                    Text('Sport'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8), // Spazio tra il box e il testo
                    Text('Study'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10)),
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 8), // Spazio tra il box e il testo
                    Text('Work'),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 500,
          height: 400,
          child: Card(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 5,
                  sections: [
                    PieChartSectionData(
                        title:
                            '${(_hoursForOtherCat / _totHours * 100).round()}%',
                        value: _hoursForOtherCat,
                        color: Colors.red),
                    PieChartSectionData(
                        title:
                            '${(_hoursForSportCat / _totHours * 100).round()}%',
                        value: _hoursForSportCat,
                        color: Colors.green),
                    PieChartSectionData(
                        title:
                            '${(_hoursForStudyCat / _totHours * 100).round()}%',
                        value: _hoursForStudyCat,
                        color: Colors.blue),
                    PieChartSectionData(
                        title:
                            '${(_hoursForWorkCat / _totHours * 100).round()}%',
                        value: _hoursForWorkCat,
                        color: Colors.yellow),
                    PieChartSectionData(
                        title: '',
                        value: _seriesForWorkCat.isNotEmpty ||
                                _seriesForOtherCat.isNotEmpty ||
                                _seriesForSportCat.isNotEmpty ||
                                _seriesForStudyCat.isNotEmpty
                            ? 0
                            : 100,
                        color: Colors.orange),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Il tuo grafico va qui...
      ],
    );
  }
}
