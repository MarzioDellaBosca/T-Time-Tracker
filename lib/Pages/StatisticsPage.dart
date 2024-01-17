import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsPage extends StatefulWidget {
  final List<Activity> activities;
  StatisticsPage({required this.activities});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Activity> get activities => widget.activities;

  List<Activity> _activitiesForOtherCat = [];
  List<Activity> _activitiesForSportCat = [];
  List<Activity> _activitiesForStudyCat = [];
  List<Activity> _activitiesForWorkCat = [];

  @override
  void initState() {
    super.initState();
    _activitiesForOtherCat = [
      for (var activity in activities)
        if (activity.getCategory() == 'Other') activity
    ];
    _activitiesForSportCat = [
      for (var activity in activities)
        if (activity.getCategory() == 'Sport') activity
    ];
    _activitiesForStudyCat = [
      for (var activity in activities)
        if (activity.getCategory() == 'Study') activity
    ];
    _activitiesForWorkCat = [
      for (var activity in activities)
        if (activity.getCategory() == 'Work') activity
    ];
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [],
        ),
        Column(
          children: [],
        )
      ],
    );
  }
}
