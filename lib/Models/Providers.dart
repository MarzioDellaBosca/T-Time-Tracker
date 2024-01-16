//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:intl/intl.dart';

class PageIndexProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int newIndex) {
    _selectedIndex = newIndex;
    notifyListeners();
  }
}

class ActivitiesProvider extends ChangeNotifier {
  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  void addActivity(Activity activity) {
    _activities.add(activity);
    sortActivitiesByDate();
  }

  void deleteActivity(Activity activity) {
    _activities.remove(activity);
    notifyListeners();
  }

  void sortActivitiesByDate() {
    _activities.sort((a, b) {
      DateTime dateA = DateFormat('dd/MM/yy').parse(a.getDate());
      DateTime dateB = DateFormat('dd/MM/yy').parse(b.getDate());
      return dateA.compareTo(dateB);
    });
    notifyListeners();
  }
}
