import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatelessWidget {
  final List<Activity> activities;
  final imgProvider;
  StatisticsPage({required this.activities, required this.imgProvider});

  List<Activity> _createSeriesForCategory(String category, String date) {
    return [
      for (var activity in activities)
        if (activity.getCategory() == category) activity
    ];
  }

  double _getHoursForCategory(List<Activity> series) {
    return series.isNotEmpty
        ? series
            .map((activity) => activity.getDuration().toDouble())
            .reduce((a, b) => a + b)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    List<Activity> seriesForOtherCat =
        _createSeriesForCategory('Other', 'default');
    List<Activity> seriesForSportCat =
        _createSeriesForCategory('Sport', 'default');
    List<Activity> seriesForStudyCat =
        _createSeriesForCategory('Study', 'default');
    List<Activity> seriesForWorkCat =
        _createSeriesForCategory('Work', 'default');

    double hoursForOtherCat = _getHoursForCategory(seriesForOtherCat);
    double hoursForSportCat = _getHoursForCategory(seriesForSportCat);
    double hoursForStudyCat = _getHoursForCategory(seriesForStudyCat);
    double hoursForWorkCat = _getHoursForCategory(seriesForWorkCat);

    double totHours = hoursForOtherCat +
                hoursForSportCat +
                hoursForStudyCat +
                hoursForWorkCat >
            0
        ? hoursForOtherCat +
            hoursForSportCat +
            hoursForStudyCat +
            hoursForWorkCat
        : 1;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgProvider.imgPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
              child: Container(
            width: 500,
            child: Center(
              child: Text(
                'Total Activities stats:',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
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
                      SizedBox(width: 8),
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
                      SizedBox(width: 8),
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
                      SizedBox(width: 8),
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
                      SizedBox(width: 8),
                      Text('Work'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          height <= 630
              ? Container()
              : Container(
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
                                    '${(hoursForOtherCat / totHours * 100).round()}%',
                                value: hoursForOtherCat,
                                color: Colors.red),
                            PieChartSectionData(
                                title:
                                    '${(hoursForSportCat / totHours * 100).round()}%',
                                value: hoursForSportCat,
                                color: Colors.green),
                            PieChartSectionData(
                                title:
                                    '${(hoursForStudyCat / totHours * 100).round()}%',
                                value: hoursForStudyCat,
                                color: Colors.blue),
                            PieChartSectionData(
                                title:
                                    '${(hoursForWorkCat / totHours * 100).round()}%',
                                value: hoursForWorkCat,
                                color: Colors.yellow),
                            PieChartSectionData(
                                title: '',
                                value: seriesForWorkCat.isNotEmpty ||
                                        seriesForOtherCat.isNotEmpty ||
                                        seriesForSportCat.isNotEmpty ||
                                        seriesForStudyCat.isNotEmpty
                                    ? 0
                                    : 100,
                                color: Colors.orange),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
