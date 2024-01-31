import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
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
        if (dateController.text.isNotEmpty &&
            !RegExp(r'^\d{2}/\d{2}/\d{2}$').hasMatch(dateController.text)) {
          Utility.errorDiag(
              'Incorrect date format. Must be dd/mm/yy.', context);
        } else if (durationController.text.isNotEmpty &&
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
        activityType =
            null; // o 'Type' se 'Type' è un'opzione nel tuo DropdownButton
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
          image: AssetImage(imgProvider
              .imgPath), // sostituisci con il tuo percorso di immagine
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
                      child: ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(activities[index]
                                      .getTitle()), // Titolo a sinistra
                                  Text(activities[index]
                                      .getDate()), // Data a destra
                                ],
                              ),
                              onTap: () {
                                selectActivity(activities[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // La tua colonna esistente
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 1.0, // Occupa tutta la larghezza disponibile
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
                                      child: TextField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          labelText: 'Title',
                                        ),
                                        style: TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        //padding: EdgeInsets.only(top: 20),
                                        child: TextField(
                                          controller: durationController,
                                          decoration: InputDecoration(
                                              labelText: 'Duration',
                                              helperStyle: TextStyle(
                                                  color: Colors.grey)),
                                          style: TextStyle(fontSize: 10),
                                          textAlign: TextAlign.center,
                                        ),
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
                                        child: ElevatedButton(
                                          onPressed: () => {},
                                          child: DropdownButton<String>(
                                            hint: Text('Type',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColorDark,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            value: activityType,
                                            elevation: 15,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            underline: Container(
                                              height: 0,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                activityType = newValue;
                                              });
                                            },
                                            items: <String>[
                                              'Work',
                                              'Sport',
                                              'Study',
                                              'Other'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  border: UnderlineInputBorder(),
                                ),
                                style: TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                                minLines: 1,
                                maxLines: 4,
                              ),
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
                                Expanded(
                                  child: FractionallySizedBox(
                                    widthFactor:
                                        1.0, // Occupa tutta la larghezza
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Title: ',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              selectedActivity!
                                                                  .getTitle(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Date: ',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              selectedActivity!
                                                                  .getDate(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Duration: ',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              '${selectedActivity!.getDuration()} h',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Description:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: 'Type: ',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: selectedActivity!
                                                              .getCategory(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(selectedActivity!
                                                .getDescription()),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FractionallySizedBox(
                    widthFactor: 1.0, // Occupa tutta la larghezza disponibile
                    child: Container(
                      /*  padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white70,
                      ),*/
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
