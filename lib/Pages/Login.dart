import 'package:flutter/material.dart'
    hide
        Key; // Importa tutto da material.dart tranne Key o conflitto con encrypt.dart
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

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

    String padKey(String key) {
      if (key.length > 32) {
        return key.substring(
            0, 32); // Se la chiave è più lunga di 32 caratteri, troncala
      } else {
        return key.padRight(32,
            '.'); // Altrimenti, aggiungi '.' alla fine fino a raggiungere 32 caratteri
      }
    }

    void toLog(String username, String password) async {
      final currentDirectory = Directory.current.path;
      final activitiesProvider =
          Provider.of<ActivitiesProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final pageProvider =
          Provider.of<PageIndexProvider>(context, listen: false);

      if (username == 'admin' && password == 'admin') {
        _userNameController.clear();
        _userPwdController.clear();
        pageProvider.selectedIndex = 1;
      } else if (!File('$currentDirectory/lib/Models/Users/$username.txt')
          .existsSync()) {
        errorDiag('Wrong username!');
        _userNameController.clear();
      } else {
        final key = Key.fromUtf8(padKey(password)); // Genera una chiave
        final file = File('$currentDirectory/lib/Models/Users/$username.txt');
        List<String> lines = await file.readAsLines();
        final iv = IV.fromBase64(lines[0]);
        final decrypter = Encrypter(AES(key));

        final decryptedPassword =
            decrypter.decrypt(Encrypted.fromBase64(lines[1]), iv: iv);

        if (decryptedPassword == password) {
          _userNameController.clear();
          _userPwdController.clear();

          List<Activity> activities = [];

          for (var i = 2; i < lines.length; i++) {
            // Decrittografa la riga
            final decryptedLine =
                decrypter.decrypt(Encrypted.fromBase64(lines[i]), iv: iv);

            // Suddividi la riga in componenti separate
            List<String> components = decryptedLine.split(', ');

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
          activitiesProvider.loadActivities(activities);
          userProvider.username = username;
          userProvider.password = password;
          userProvider.iv = iv;
          pageProvider.selectedIndex = 1;
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
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final pageProvider =
          Provider.of<PageIndexProvider>(context, listen: false);

      if (await file.exists()) {
        errorDiag('A user with this username already exists.');
        _userNameController.clear();
      } else if (username == 'admin') {
        errorDiag('This username is reserved.');
        _userNameController.clear();
      } else if (username == '') {
        errorDiag('Username cannot be empty.');
      } else if (password.length > 32) {
        errorDiag('Password cannot be longer than 32 characters.');
        _userPwdController.clear();
      } else if (username.length > 32) {
        errorDiag('Username cannot be longer than 32 characters.');
        _userNameController.clear();
      } else {
        final iv = IV.fromSecureRandom(16); // Genera un IV casuale di 16 byte

        await file.create(recursive: true);

        await file.writeAsString(iv.base64);

        userProvider.username = username;
        userProvider.password = password;
        userProvider.iv = iv;
        pageProvider.selectedIndex = 1;
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
