import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Widgets/ActivityDescription.dart';
import 'package:flutter_tracker_application/Widgets/ActivityListView.dart';
import 'package:flutter_tracker_application/Widgets/MyDropDownButton.dart';
import 'package:flutter_tracker_application/Widgets/MyInputTextField.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tracker_application/Models/Utilities.dart';
import 'package:intl/intl.dart';

class ActivitiesPage extends StatefulWidget {
  final List<Activity> activities;
  final imgProvider;
  ActivitiesPage({required this.activities, required this.imgProvider});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final durationController = TextEditingController();
  final descriptionController = TextEditingController();
  String? activityType;

  List<Activity> get activities => widget.activities;
  ImgProvider get imgProvider => widget.imgProvider;
  Activity? selectedActivity;

  void deleteActivity() {
    if (selectedActivity != null) {
      Provider.of<ActivitiesProvider>(context, listen: false)
          .deleteActivity(selectedActivity!);
      setState(() {
        selectedActivity = null;
      });
    }
  }

  void modifyActivity() {
    if (selectedActivity != null) {
      var activitiesProvider =
          Provider.of<ActivitiesProvider>(context, listen: false);
      int index = activitiesProvider.activities.indexOf(selectedActivity!);

      if (index != -1) {
        if (durationController.text.isNotEmpty &&
            Utility.isNotValidDuration(durationController.text)) {
          Utility.errorDiag('Incorrect duration format. Must be hh.', context);
        } else {
          activitiesProvider.modifyActivity(
              index,
              titleController.text,
              dateController.text,
              durationController.text,
              descriptionController.text,
              activityType ?? 'Other');
          titleController.clear();
          dateController.clear();
          descriptionController.clear();
          durationController.clear();
          setState(() {
            activityType = null;
          });
        }
      }
    }
  }

  void addActivity() {
    String title = titleController.text;
    String date = dateController.text;
    String duration = durationController.text;
    String description = descriptionController.text;
    String category = activityType ?? 'Other';

    if (duration.isEmpty) duration = '0';
    if (description.isEmpty) description = 'No description';

    if (Utility.isNotValidDuration(duration)) {
      Utility.errorDiag('Incorrect duration format. Must be hh.', context);
    } else if (date.isEmpty) {
      Utility.errorDiag('You have to chose a date!', context);
    } else {
      Activity newActivity = Activity(
          title: title,
          date: date,
          description: description,
          duration: int.parse(duration),
          category: category);

      Provider.of<ActivitiesProvider>(context, listen: false)
          .addActivity(newActivity);

      titleController.clear();
      dateController.clear();
      descriptionController.clear();
      durationController.clear();
      setState(() {
        activityType = null;
      });
    }
  }

  void selectActivity(Activity activity) {
    setState(() {
      selectedActivity = activity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgProvider.imgPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: FocusScope(
                node: FocusScopeNode(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Activities:", style: style),
                    Expanded(
                      child: ActivityListView(
                        activities: activities,
                        selectActivity: selectActivity,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white70,
                        ),
                        child: FocusScope(
                          node: FocusScopeNode(),
                          child: Column(
                            children: [
                              Container(
                                height: 80.0,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: MyInputTextField(
                                        controller: titleController,
                                        label: 'Title',
                                        type: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: MyInputTextField(
                                        controller: durationController,
                                        label: 'Duration',
                                        type: 1,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 60.0,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          ).then((date) {
                                            if (date != null) {
                                              dateController.text =
                                                  DateFormat('dd/MM/yy')
                                                      .format(date);
                                            }
                                          });
                                        },
                                        child: Text('Date'),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                          height: 32.0,
                                          child: MyDropDownButtor(
                                              value: activityType,
                                              hint: 'Type',
                                              items: <String>[
                                                'Work',
                                                'Sport',
                                                'Study',
                                                'Other'
                                              ],
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  if (newValue != null)
                                                    activityType = newValue;
                                                  else {
                                                    activityType = 'Other';
                                                  }
                                                });
                                              })),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              MyInputTextField(
                                  controller: descriptionController,
                                  type: 2,
                                  label: 'Description'),
                              SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    addActivity();
                                  },
                                  child: Text('Add'),
                                ),
                              ),
                              if (selectedActivity != null)
                                ActivityDescription(activity: selectedActivity!)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                deleteActivity();
                              },
                              child: Text("Delete")),
                          SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                modifyActivity();
                              },
                              child: Text("Modify")),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
