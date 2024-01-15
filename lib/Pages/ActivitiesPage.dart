import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:provider/provider.dart';

class ActivitiesPage extends StatefulWidget {
  final List<Activity> activities;
  ActivitiesPage({required this.activities});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Activity> get activities => widget.activities;
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
        if (titleController.text.isNotEmpty) {
          activitiesProvider.activities[index].setTitle(titleController.text);
          titleController.clear();
        }
        if (dateController.text.isNotEmpty) {
          activitiesProvider.activities[index].setDate(dateController.text);
          dateController.clear();
        }
        if (descriptionController.text.isNotEmpty) {
          activitiesProvider.activities[index]
              .setDescription(descriptionController.text);
          descriptionController.clear();
        }

        // Notifica il provider che le attività sono cambiate
        activitiesProvider.notifyListeners();
      }
    }
  }

  void addActivity() {
    String title = titleController.text;
    String date = dateController.text;
    String description = descriptionController.text;
    Activity newActivity =
        Activity(title: title, date: date, description: description);

    Provider.of<ActivitiesProvider>(context, listen: false)
        .addActivity(newActivity);

    titleController.clear();
    dateController.clear();
    descriptionController.clear();
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

    // Esempio di lista di stringhe, sostituisci con i tuoi dati

    return Row(
      children: [
        Expanded(
          child: Center(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(activities[index]
                                  .getTitle()), // Titolo a sinistra
                              Text(
                                  activities[index].getDate()), // Data a destra
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
                      child: Column(
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                helperText: 'dd/mm/yy',
                                helperStyle: TextStyle(color: Colors.grey)),
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
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
                                widthFactor: 1.0, // Occupa tutta la larghezza
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Title: ',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: selectedActivity!
                                                          .getTitle(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ],
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Date: ',
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: selectedActivity!
                                                          .getDate(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Description:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                            selectedActivity!.getDescription()),
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
    );
  }
}
