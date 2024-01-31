import 'package:flutter/material.dart'
    hide
        Key; // Importa tutto da material.dart tranne Key o conflitto con encrypt.dart
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_tracker_application/Models/Utilities.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserDataHandler {
  static void toLog(
      String username, String password, BuildContext context) async {
    final activitiesProvider =
        Provider.of<ActivitiesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final pageProvider = Provider.of<PageIndexProvider>(context, listen: false);
    final imgProvider = Provider.of<ImgProvider>(context, listen: false);

    if (username == 'admin' && password == 'admin') {
      userProvider.username = username;
      userProvider.password = password;
      userProvider.iv = IV.fromLength(16);
      imgProvider.imgPath = '1';
      pageProvider.selectedIndex = 1;
    } else if (!kIsWeb) {
      final currentDirectory = Directory.current.path;

      if (!File('$currentDirectory/lib/Models/Users/$username.txt')
          .existsSync()) {
        Utility.errorDiag('Wrong username!', context);
      } else {
        final key = Key.fromUtf8(Utility.padKey(password));
        final file = File('$currentDirectory/lib/Models/Users/$username.txt');
        List<String> lines = await file.readAsLines();
        final iv = IV.fromBase64(lines[0]);
        final decrypter = Encrypter(AES(key));

        try {
          final decryptedPassword =
              decrypter.decrypt(Encrypted.fromBase64(lines[1]), iv: iv);

          if (decryptedPassword == password) {
            List<Activity> activities = [];

            for (var i = 2; i < lines.length; i++) {
              final decryptedLine =
                  decrypter.decrypt(Encrypted.fromBase64(lines[i]), iv: iv);

              List<String> components = decryptedLine.split(', ');

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
            imgProvider.imgPath = '1';
            pageProvider.selectedIndex = 1;
          } else {
            Utility.errorDiag('Wrong password!', context);
          }
        } catch (e) {
          Utility.errorDiag('Wrong password!', context);
        }
      }
    } else {
      loadUser(username, password, userProvider, activitiesProvider,
          pageProvider, imgProvider, context);
    }
  }

  static void toReg(
      String username, String password, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final pageProvider = Provider.of<PageIndexProvider>(context, listen: false);
    final imgProvider = Provider.of<ImgProvider>(context, listen: false);

    if (username == 'admin') {
      Utility.errorDiag('This username is reserved.', context);
    } else if (username == '' || password == '') {
      Utility.errorDiag('Username and password cannot be empty.', context);
    } else if (password.length > 32 || username.length > 32) {
      Utility.errorDiag(
          'Username and password cannot be longer than 32 characters.',
          context);
    } else {
      if (!kIsWeb) {
        final currentDirectory = Directory.current.path;
        final filePath = '$currentDirectory/lib/Models/Users/$username.txt';
        final file = File(filePath);
        if (file.existsSync()) {
          Utility.errorDiag(
              'A user with this username already exists.', context);
        } else {
          final iv = IV.fromSecureRandom(16); // Genera un IV casuale di 16 byte

          await file.create(recursive: true);

          await file.writeAsString(iv.base64);

          userProvider.username = username;
          userProvider.password = password;
          userProvider.iv = iv;
          imgProvider.imgPath = '1';
          pageProvider.selectedIndex = 1;
        }
      } else {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userJson = prefs.getString(username);

        if (userJson != null) {
          Utility.errorDiag(
              'A user with this username already exists.', context);
        } else {
          userProvider.username = username;
          userProvider.password = password;
          userProvider.iv = IV.fromSecureRandom(16);
          imgProvider.imgPath = '1';
          pageProvider.selectedIndex = 1;
        }
      }
    }
  }

  static void handleUserChange(String oldUsername, String newUsername,
      String oldPassword, String newPassword, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (newPassword != '') {
      if (oldUsername == 'admin') {
        Utility.errorDiag(
            'An admin doesn\'t need to change his password, it\'s precisely the way he needs too!',
            context);
      } else {
        if (oldPassword != newPassword) {
          userProvider.password = newPassword;
        } else {
          Utility.errorDiag('Password already exists!', context);
        }
      }
    }
    if (newUsername != '') {
      if (oldUsername == 'admin') {
        Utility.errorDiag(
            'An admin doesn\'t need to change his name, it\'s precisely the way he needs too!',
            context);
      } else {
        if (!kIsWeb) {
          final currentDirectory = Directory.current.path;
          final filePath =
              '$currentDirectory/lib/Models/Users/$newUsername.txt';
          final file = File(filePath);
          if (file.existsSync()) {
            Utility.errorDiag('Username already exists!', context);
          } else {
            await File('$currentDirectory/lib/Models/Users/$oldUsername.txt')
                .delete();
            userProvider.username = newUsername;
          }
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          String? userJson = prefs.getString(newUsername);

          if (userJson != null) {
            Utility.errorDiag('Username already exists!', context);
          } else {
            await prefs.remove(oldUsername);
            userProvider.username = newUsername;
          }
        }
      }
    }
  }

  static void saveUserData(String username, String password, IV iv,
      List<Activity> activities) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = Key.fromUtf8(Utility.padKey(password));
    final encrypter = Encrypter(AES(key));

    final encryptedPassword = encrypter.encrypt(password, iv: iv);

    Map<String, dynamic> userData = {
      'password': encryptedPassword.base64,
      'iv': iv.base64,
    };

    if (activities.isNotEmpty) {
      final encryptedActivities = encrypter.encrypt(
        activities.map((activity) => activity.toString()).join('\n'),
        iv: iv,
      );

      userData['activities'] = encryptedActivities.base64;
    }

    String userJson = jsonEncode(userData);

    await prefs.setString(username, userJson);
  }

  static void loadUser(
      String username,
      String password,
      UserProvider userProvider,
      ActivitiesProvider activitiesProvider,
      PageIndexProvider pageProvider,
      ImgProvider imgProvider,
      BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final key = Key.fromUtf8(Utility.padKey(password));
    final encrypter = Encrypter(AES(key));

    String? userJson = prefs.getString(username);

    if (userJson == null) {
      Utility.errorDiag('Wrong username!', context);
    } else {
      Map<String, dynamic> userData = jsonDecode(userJson);
      final iv = IV.fromBase64(userData['iv']);
      final encryptedPassword = Encrypted.fromBase64(userData['password']);
      try {
        final decriptedPassword = encrypter.decrypt(encryptedPassword, iv: iv);
        if (decriptedPassword == password) {
          if (userData['activities'] != null) {
            final encryptedActivities =
                Encrypted.fromBase64(userData['activities']);
            final activitiesString =
                encrypter.decrypt(encryptedActivities, iv: iv);
            final stringActivities = activitiesString.split('\n');
            List<Activity> activities = [];
            for (var activity in stringActivities) {
              List<String> components = activity.split(', ');

              Activity act = Activity(
                title: components[0],
                date: components[1],
                description: components[2],
                duration: int.parse(components[3]),
                category: components[4],
              );
              activities.add(act);
            }
            activitiesProvider.loadActivities(activities);
          }
          userProvider.username = username;
          userProvider.password = decriptedPassword;
          userProvider.iv = iv;
          imgProvider.imgPath = '1';
          pageProvider.selectedIndex = 1;
        } else {
          Utility.errorDiag('Wrong password!', context);
          Exception();
        }
      } catch (e) {
        print(e);
        Utility.errorDiag('Wrong password!', context);
      }
    }
  }

  static void deleteUserData(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(username);
  }
}
