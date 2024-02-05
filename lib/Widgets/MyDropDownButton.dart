import 'package:flutter/material.dart';

class MyDropDownButtor extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final Function onChanged;

  MyDropDownButtor(
      {required this.value,
      required this.hint,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {},
      child: DropdownButton<String>(
        hint: Text(hint,
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
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
