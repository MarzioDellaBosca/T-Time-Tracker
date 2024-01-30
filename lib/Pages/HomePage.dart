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
import 'package:flutter_tracker_application/Models/Utilities.dart';

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

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;
  String get username => widget.username;
  String get password => widget.password;
  IV get iv => widget.iv;
  List<Activity> get activities => widget.activities;

  void handleLogout() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // aspetta che il widget sia costruito prima di operare su userProvider
      final activitiesProvider =
          Provider.of<ActivitiesProvider>(context, listen: false);
      final pageProvider =
          Provider.of<PageIndexProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (username != 'admin') {
        final currentDirectory = Directory.current.path;
        final file = File('$currentDirectory/lib/Models/Users/$username.txt');
        final key = Key.fromUtf8(Utility.padKey(password));
        final encrypter = Encrypter(AES(key));

        final encryptedPassword = encrypter.encrypt(password, iv: iv);

        await file.writeAsString('${iv.base64}\n${encryptedPassword.base64}\n');

        for (var activity in activitiesProvider.activities) {
          final encryptedActivity = encrypter.encrypt(
            activity.toString(),
            iv: iv,
          );
          await file.writeAsString('${encryptedActivity.base64}\n',
              mode: FileMode.append);
        }
        userProvider.iv = IV.fromLength(16);
      }
      if (activitiesProvider.activities.isNotEmpty) {
        activitiesProvider.resetActivities();
      }

      userProvider.username = '';
      userProvider.password = '';

      Future.delayed(Duration.zero, () {
        // aspetta che il widget sia costruito ritardando la funzione
        pageProvider.selectedIndex = 0;
      });
    });
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
