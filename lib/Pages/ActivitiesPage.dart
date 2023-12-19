import 'package:flutter/material.dart';

class ActivitiesPage extends StatefulWidget {
  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  void deleteActivity() {}
  void modifyActivity() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    // Esempio di lista di stringhe, sostituisci con i tuoi dati
    List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

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
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
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
                          Text("Description:"),
                          SizedBox(height: 10),
                          Text("Testo di prova"),
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
