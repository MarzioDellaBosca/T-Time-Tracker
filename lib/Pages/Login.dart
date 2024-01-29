import 'package:flutter/material.dart'
    hide
        Key; // Importa tutto da material.dart tranne Key o conflitto con encrypt.dart
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_tracker_application/Models/Utilities.dart';

class Login extends StatelessWidget {
  final _userNameController = TextEditingController();
  final _userPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        Utility.errorDiag('Wrong username!', context);
        _userNameController.clear();
      } else {
        final key = Key.fromUtf8(Utility.padKey(password)); // Genera una chiave
        final file = File('$currentDirectory/lib/Models/Users/$username.txt');
        List<String> lines = await file.readAsLines();
        final iv = IV.fromBase64(lines[0]);
        final decrypter = Encrypter(AES(key));

        try {
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
            Utility.errorDiag('Wrong password!', context);
            _userPwdController.clear();
            return;
          }
        } catch (e) {
          Utility.errorDiag('Wrong password!', context);
          _userPwdController.clear();
          return;
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
        Utility.errorDiag('A user with this username already exists.', context);
        _userNameController.clear();
      } else if (username == 'admin') {
        Utility.errorDiag('This username is reserved.', context);
        _userNameController.clear();
      } else if (username == '') {
        Utility.errorDiag('Username cannot be empty.', context);
      } else if (password.length > 32) {
        Utility.errorDiag(
            'Password cannot be longer than 32 characters.', context);
        _userPwdController.clear();
      } else if (username.length > 32) {
        Utility.errorDiag(
            'Username cannot be longer than 32 characters.', context);
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
