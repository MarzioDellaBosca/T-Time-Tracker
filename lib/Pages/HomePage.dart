import 'dart:io';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Models/UserDataHandler.dart';
import 'package:flutter_tracker_application/Pages/ActivitiesPage.dart';
import 'package:flutter_tracker_application/Pages/CalendarPage.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Pages/HelpPage.dart';
import 'package:flutter_tracker_application/Pages/Home.dart';
import 'package:flutter_tracker_application/Pages/SettingsPage.dart';
import 'package:flutter_tracker_application/Pages/StatisticsPage.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_tracker_application/Models/Utilities.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      final activitiesProvider =
          Provider.of<ActivitiesProvider>(context, listen: false);
      final pageProvider =
          Provider.of<PageIndexProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (username != 'admin') {
        if (!kIsWeb) {
          final currentDirectory = Directory.current.path;
          final file = File('$currentDirectory/lib/Models/Users/$username.txt');
          final key = Key.fromUtf8(Utility.padKey(password));
          final encrypter = Encrypter(AES(key));

          final encryptedPassword = encrypter.encrypt(password, iv: iv);

          await file
              .writeAsString('${iv.base64}\n${encryptedPassword.base64}\n');

          for (var activity in activitiesProvider.activities) {
            final encryptedActivity = encrypter.encrypt(
              activity.toString(),
              iv: iv,
            );
            await file.writeAsString('${encryptedActivity.base64}\n',
                mode: FileMode.append);
          }
        } else {
          UserDataHandler.deleteUserData(username);
          UserDataHandler.saveUserData(
            username,
            password,
            iv,
            activitiesProvider.activities,
          );
        }

        userProvider.iv = IV.fromLength(16);
      }
      if (activitiesProvider.activities.isNotEmpty) {
        activitiesProvider.resetActivities();
      }

      userProvider.username = '';
      userProvider.password = '';

      Future.delayed(Duration.zero, () {
        pageProvider.selectedIndex = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var activitiesProvider = Provider.of<ActivitiesProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    var imgProvider = Provider.of<ImgProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Widget page = const Placeholder();

    switch (selectedIndex) {
      case 0:
        page = Home(
          username: username,
          imgProvider: imgProvider,
        );
        break;
      case 1:
        page = ActivitiesPage(
            activities: activitiesProvider.activities,
            imgProvider: imgProvider);
        break;
      case 2:
        page = StatisticsPage(
            activities: activitiesProvider.activities,
            imgProvider: imgProvider);
        break;
      case 3:
        page = CalendarPage(
            activities: activitiesProvider.activities,
            imgProvider: imgProvider);
        break;
      case 4:
        page =
            SettingsPage(userProvider: userProvider, imgProvider: imgProvider);
        break;
      case 5:
        page = HelpPage(imgProvider: imgProvider);
        break;
      case 6:
        handleLogout();
        break;
      default:
        page = const Placeholder();
        break;
    }

    return height <= 300 ||
            (height <= 350 && selectedIndex == 3) ||
            (height <= 400 && selectedIndex == 4) ||
            (height <= 450 && selectedIndex == 5) ||
            (height <= 500 && selectedIndex == 6)
        ? Container()
        : Scaffold(
            body: Row(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: width > 850
                        ? MediaQuery.of(context).size.width * 0.2
                        : 100,
                    child: NavigationRail(
                      backgroundColor: Colors.blueGrey.shade100,
                      extended: width > 900 ? true : false,
                      leading: Column(
                        children: [
                          SizedBox(height: 20),
                        ],
                      ),
                      trailing: Column(
                        children: [
                          SizedBox(height: 20),
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
                        if (height >= 300)
                          NavigationRailDestination(
                            icon: Icon(Icons.insert_chart_outlined_rounded),
                            label: Text('Stats'),
                          ),
                        if (height >= 350)
                          NavigationRailDestination(
                            icon: Icon(Icons.calendar_month_outlined),
                            label: Text('Calendar'),
                          ),
                        if (height >= 400)
                          NavigationRailDestination(
                            icon: Icon(Icons.handyman),
                            label: Text('Settings'),
                          ),
                        if (height >= 400)
                          NavigationRailDestination(
                            icon: Icon(Icons.help_outline),
                            label: Text('Help'),
                          ),
                        if (height >= 450)
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
