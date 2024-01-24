import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';

class Login extends StatelessWidget {
  final _userNameController = TextEditingController();
  final _userPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void errorDiag(String msg) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'Error!',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void toLog(String username, String password) async {
      final currentDirectory = Directory.current.path;
      if (username == 'admin' && password == 'admin') {
        _userNameController.clear();
        _userPwdController.clear();
        Provider.of<PageIndexProvider>(context, listen: false).selectedIndex =
            1;
      } else if (!File('$currentDirectory/lib/Models/Users/$username.txt')
          .existsSync()) {
        errorDiag('Wrong username!');
        _userNameController.clear();
      } else {
        final file = File('$currentDirectory/lib/Models/Users/$username.txt');
        final linesStream =
            file.openRead().transform(utf8.decoder).transform(LineSplitter());
        final firstLine = await linesStream.first;
        if (firstLine == password) {
          _userNameController.clear();
          _userPwdController.clear();

          if (username != 'admin') {
            List<String> lines = await file.readAsLines();
            List<Activity> activities = [];

            for (var i = 1; i < lines.length; i++) {
              // Suddividi la riga in componenti separate
              List<String> components = lines[i].split(', ');

              // Crea un'attività da quelle componenti
              Activity activity = Activity(
                title: components[0],
                date: components[1],
                description: components[2],
                duration: int.parse(components[3]),
                category: components[4],
              );
              activities.add(activity);
            }
            Provider.of<ActivitiesProvider>(context, listen: false)
                .loadActivities(activities);
          }

          Provider.of<UserProvider>(context, listen: false).username = username;
          Provider.of<PageIndexProvider>(context, listen: false).selectedIndex =
              1;
        } else {
          errorDiag('Wrong password!');
          _userPwdController.clear();
        }
      }
    }

    void toReg(String username, String password) async {
      final currentDirectory = Directory.current.path;
      final filePath = '$currentDirectory/lib/Models/Users/$username.txt';
      final file = File(filePath);

      if (await file.exists()) {
        errorDiag('A user with this username already exists.');
        _userNameController.clear();
      } else if (username == 'admin') {
        errorDiag('This username is reserved.');
        _userNameController.clear();
      } else if (username == '') {
        errorDiag('Username cannot be empty.');
      } else {
        await file.create(recursive: true);
        await file.writeAsString(password);

        Provider.of<PageIndexProvider>(context, listen: false).selectedIndex =
            1;
      }
    }

    final theme = Theme.of(context);
    return Container(
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Login",
                      style: theme.textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.primary)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _userPwdController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                style: TextStyle(fontSize: 10),
                obscureText: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Registration button logic
                      toReg(_userNameController.text, _userPwdController.text);
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Login button logic
                      toLog(_userNameController.text, _userPwdController.text);
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
