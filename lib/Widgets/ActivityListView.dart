import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';

class ActivityListView extends StatelessWidget {
  final List<Activity> activities;
  final Function(Activity) selectActivity;

  ActivityListView({required this.activities, required this.selectActivity});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(activities[index].getTitle()), // Titolo a sinistra
                Text(activities[index].getDate()), // Data a destra
              ],
            ),
            onTap: () {
              selectActivity(activities[index]);
            },
          ),
        );
      },
    );
  }
}
