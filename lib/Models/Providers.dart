import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Activity.dart';
import 'package:intl/intl.dart';
import 'package:encrypt/encrypt.dart';

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

  //index, titleController.text, dateController.text, durationController.text, descriptionController.text, activityType
  void modifyActivity(int index, String title, String date, String duration,
      String description, String activityType) {
    if (title.isNotEmpty) {
      _activities[index].setTitle(title);
    }
    if (duration.isNotEmpty) {
      _activities[index].setDuration(int.parse(duration));
    }
    if (description.isNotEmpty) {
      _activities[index].setDescription(description);
    }
    if (activityType.isNotEmpty) {
      _activities[index].setCategory(activityType);
    }
    if (date.isNotEmpty) {
      _activities[index].setDate(date);
      sortActivitiesByDate();
    }
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

  void resetActivities() {
    _activities = [];
    notifyListeners();
  }

  void loadActivities(List<Activity> activities) {
    _activities = activities;
    notifyListeners();
  }
}

class UserProvider extends ChangeNotifier {
  String _username = '';
  String _password = '';
  IV _iv = IV.fromLength(16);

  String get username => _username;
  String get password => _password;
  IV get iv => _iv;

  set username(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  set password(String newPassword) {
    _password = newPassword;
    notifyListeners();
  }

  set iv(IV newIv) {
    _iv = newIv;
    notifyListeners();
  }
}
