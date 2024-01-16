import 'dart:math';

class Activity {
  String _title;
  final int _id;
  String _date;
  String _description;
  int _duration;

  Activity(
      {required String title,
      required String date,
      required String description,
      required int duration})
      : _title = title,
        _date = date,
        _description = description,
        _duration = duration,
        _id = Random().nextInt(10000000);

  void setDescription(String newDescription) {
    this._description = newDescription;
  }

  void setDate(String newDate) {
    this._date = newDate;
  }

  void setTitle(String newTitle) {
    this._title = newTitle;
  }

  void setDuration(int newDuration) {
    this._duration = newDuration;
  }

  String getDescription() {
    return this._description;
  }

  String getDate() {
    return this._date;
  }

  String getTitle() {
    return this._title;
  }

  int getDuration() {
    return this._duration;
  }

  int getId() {
    return this._id;
  }
}
