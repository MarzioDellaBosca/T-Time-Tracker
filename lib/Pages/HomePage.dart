import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Pages/ActivitiesPage.dart';
import 'package:flutter_tracker_application/Pages/CalendarPage.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Pages/Home.dart';
import 'package:flutter_tracker_application/Pages/StatisticsPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String username;
  final List<Activity> activities;
  HomePage({required this.username, required this.activities});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  String get username => widget.username;
  List<Activity> get activities => widget.activities;

  void handleLogout() async {
    if (username != 'admin') {
      final currentDirectory = Directory.current.path;
      final file = File('$currentDirectory/lib/Models/Users/$username.txt');

      List<String> lines = await file.readAsLines();

      lines = [
        lines.first, // Mantieni la password già presente nella prima riga
        ...activities.map((activity) =>
            activity.toString()), // Aggiungi una riga per ogni attività
      ];
      await file.writeAsString(lines.join('\n'));
    }
    Provider.of<ActivitiesProvider>(context, listen: false).resetActivities();

    Future.delayed(Duration.zero, () {
      // aspetta che il widget sia costruito ritardando la funzione
      Provider.of<PageIndexProvider>(context, listen: false).selectedIndex = 0;
    }); // porta alla pagina di login
  }

  @override
  Widget build(BuildContext context) {
    var activitiesProvider = Provider.of<ActivitiesProvider>(context);
    Widget page = const Placeholder();
    print(username);

    switch (selectedIndex) {
      case 0:
        page = Home();
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
