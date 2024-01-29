import 'dart:io';

import 'package:flutter/material.dart' hide Key;
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Pages/ActivitiesPage.dart';
import 'package:flutter_tracker_application/Pages/CalendarPage.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Pages/Home.dart';
import 'package:flutter_tracker_application/Pages/StatisticsPage.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String password;
  final IV iv;
  final List<Activity> activities;
  HomePage(
      {required this.username,
      required this.password,
      required this.iv,
      required this.activities});

  String padKey(String key) {
    if (key.length > 32) {
      return key.substring(
          0, 32); // Se la chiave è più lunga di 32 caratteri, troncala
    } else {
      return key.padRight(32,
          '.'); // Altrimenti, aggiungi '.' alla fine fino a raggiungere 32 caratteri
    }
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  String get username => widget.username;
  String get password => widget.password;
  IV get iv => widget.iv;
  List<Activity> get activities => widget.activities;

  String padKey(String key) {
    if (key.length > 32) {
      return key.substring(
          0, 32); // Se la chiave è più lunga di 32 caratteri, troncala
    } else {
      return key.padRight(32,
          '.'); // Altrimenti, aggiungi '.' alla fine fino a raggiungere 32 caratteri
    }
  }

  void handleLogout() async {
    final activitiesProvider =
        Provider.of<ActivitiesProvider>(context, listen: false);
    final pageProvider = Provider.of<PageIndexProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (username != 'admin') {
      final currentDirectory = Directory.current.path;
      final file = File('$currentDirectory/lib/Models/Users/$username.txt');
      final key = Key.fromUtf8(padKey(password));
      final encrypter = Encrypter(AES(key));

      final encryptedPassword = encrypter.encrypt(password, iv: iv);

      // Scrivi l'IV e la password criptata nel file
      await file.writeAsString('${iv.base64}\n${encryptedPassword.base64}\n');

      // Cripta e scrivi ogni attività
      for (var activity in activitiesProvider.activities) {
        final encryptedActivity = encrypter.encrypt(
          activity.toString(),
          iv: iv,
        );
        await file.writeAsString('${encryptedActivity.base64}\n',
            mode: FileMode.append);
      }
    }
    activitiesProvider.resetActivities();
    userProvider.username = '';
    userProvider.password = '';
    userProvider.iv = IV.fromLength(16);

    Future.delayed(Duration.zero, () {
      // aspetta che il widget sia costruito ritardando la funzione
      pageProvider.selectedIndex = 0;
    }); // porta alla pagina di login
  }

  @override
  Widget build(BuildContext context) {
    var activitiesProvider = Provider.of<ActivitiesProvider>(context);
    Widget page = const Placeholder();
    print(username);

    switch (selectedIndex) {
      case 0:
        page = Home(username: username);
        break;
      case 1:
        page = ActivitiesPage(activities: activitiesProvider.activities);
        break;
      case 2:
        page = StatisticsPage(activities: activitiesProvider.activities);
        break;
      case 3:
        page = CalendarPage(activities: activitiesProvider.activities);
        break;
      case 4:
        page = const Placeholder();
        break;
      case 5:
        page = const Placeholder();
        break;
      case 6:
        handleLogout();
        break;
      default:
        page = const Placeholder();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('T_Tracker'),
      ),
      body: Row(
        children: [
          SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: NavigationRail(
                backgroundColor: Colors.blueGrey.shade100,
                extended: true,
                leading: Column(
                  children: [
                    SizedBox(height: 20), // Aggiungi spazio sopra
                  ],
                ),
                trailing: Column(
                  children: [
                    SizedBox(height: 20), // Aggiungi spazio sotto
                  ],
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Activities'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.insert_chart_outlined_rounded),
                    label: Text('Stats'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    label: Text('Calendar'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.handyman),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.help_outline),
                    label: Text('Help'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 102, 156, 184),
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

/*
Future<String> _determineIP() async {
    final responseIp = await http.get(Uri.parse('https://api.ipify.org'));
    if (responseIp.statusCode == 200) {
      return responseIp.body;
    } else {
      print(responseIp.statusCode);
      return 'error';
    }
  }

  Future<List<String>> _determineLoc(String ip) async {
    final responseLoc = await http.get(Uri.parse(
        'https://api.ipgeolocation.io/ipgeo?apiKey=3053e1109ad84501acd6ed29471d2ccb&ip=$ip'));
    if (responseLoc.statusCode == 200) {
      String loc = responseLoc.body;
      //print(loc);

      Map<String, dynamic> map = json.decode(loc);
      print(map['city']);
      print(map['latitude']);
      print(map['longitude']);

      return [map['city'], map['latitude'], map['longitude']];
    } else {
      print(responseLoc.statusCode);
      return ['error'];
    }
  }

  Future<int> _determineCond(String lat, String lon) async {
    final responseWeather = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=42e97e9acd8667854d957907b52ea325&units=metric'));

    if (responseWeather.statusCode == 200) {
      String weather = responseWeather.body;
      Map<String, dynamic> map = json.decode(weather);
      print(map['weather'][0]['id']);
      return map['weather'][0]['id'];
    } else {
      print(responseWeather.statusCode);
      return -1;
    }
  }
*/
