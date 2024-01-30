import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'dart:io';
import 'package:flutter_tracker_application/Models/Utilities.dart';

class SettingsPage extends StatefulWidget {
  final userProvider;

  SettingsPage({required this.userProvider});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userNameController = TextEditingController();
  final _userPwdController = TextEditingController();
  UserProvider get userProvider => widget.userProvider;

  void handleUserChange() async {
    final oldUsername = userProvider.username;
    final currentDirectory = Directory.current.path;
    final filePath =
        '$currentDirectory/lib/Models/Users/${_userNameController.text}.txt';
    final file = File(filePath);

    if (_userPwdController.text != '') {
      if (userProvider.username == 'admin') {
        Utility.errorDiag(
            'An admin doesn\'t need to change his password, it\'s precisely the way he needs too!',
            context);
      } else {
        if (userProvider.password != _userPwdController.text) {
          userProvider.password = _userPwdController.text;
        } else {
          Utility.errorDiag('Password already exists!', context);
        }
      }
      _userPwdController.clear();
    }
    if (_userNameController.text != '') {
      if (userProvider.username == 'admin') {
        Utility.errorDiag(
            'An admin doesn\'t need to change his name, it\'s precisely the way he needs too!',
            context);
      } else {
        if (file.existsSync()) {
          Utility.errorDiag('Username already exists!', context);
        } else {
          userProvider.username = _userNameController.text;

          await File('$currentDirectory/lib/Models/Users/$oldUsername.txt')
              .delete();
        }
      }
      _userNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          margin: EdgeInsets.all(10),
          child: FocusScope(
            node: FocusScopeNode(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Change username:',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _userPwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Change password:',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    handleUserChange();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
