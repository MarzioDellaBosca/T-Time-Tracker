import 'package:flutter/material.dart';

class MyDropDownButtor extends StatelessWidget {
  final int type;
  final String value;
  final String hint;
  final List<String> items;
  final Function onChanged;

  MyDropDownButtor(
      {required this.type,
      required this.value,
      required this.hint,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return type == 1
        ? ElevatedButton(
            onPressed: () => {},
            child: DropdownButton<String>(
              hint: Text('Type',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600)),
              value: value,
              elevation: 15,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                onChanged(newValue!);
                ;
              },
              items: <String>['Work', 'Sport', 'Study', 'Other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        : ElevatedButton(
            onPressed: () => {},
            child: DropdownButton<String>(
              hint: Text('Change theme',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w600)),
              value: value,
              elevation: 15,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w600),
              underline: Container(
                height: 0,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                onChanged(newValue!);
              },
              items: <String>[
                'Img 1',
                'Img 2',
                'Img 3',
                'Img 4',
                'Img 5',
                'Img 6',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          );
  }
}
