import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:flutter_tracker_application/Pages/ActivitiesPage.dart';
import 'package:flutter_tracker_application/Pages/CalendarPage.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  List<Activity> activities = [];

  void handleLogout() {
    Future.delayed(Duration.zero, () {
      // aspetta che il widget sia costruito ritardando la funzione
      Provider.of<PageIndexProvider>(context, listen: false).selectedIndex = 0;
    }); // porta alla pagina di login
  }

  @override
  Widget build(BuildContext context) {
    var activitiesProvider = Provider.of<ActivitiesProvider>(context);
    Widget page = const Placeholder();

    switch (selectedIndex) {
      case 0:
        page = const Placeholder();
        break;
      case 1:
        page = ActivitiesPage(activities: activitiesProvider.activities);
        break;
      case 2:
        page = const Placeholder();
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
