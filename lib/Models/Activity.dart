import 'dart:math';

class Activity {
  final String _title;
  final int _id;
  String _date;
  String? _description;

  Activity({required String title, required String date, String? description})
      : _title = title,
        _date = date,
        _description = description,
        _id = Random().nextInt(10000000);

  void setDescription(String newDescription) {
    this._description = newDescription;
  }

  void setDate(String newDate) {
    this._date = newDate;
  }

  String getDescription() {
    return this._description ?? "No description";
  }

  String getDate() {
    return this._date;
  }

  String getTitle() {
    return this._title;
  }

  int getId() {
    return this._id;
  }
}
