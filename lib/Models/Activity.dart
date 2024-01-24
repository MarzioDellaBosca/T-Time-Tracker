class Activity {
  String _title;
  String _date;
  String _description;
  int _duration;
  String _category;

  Activity(
      {required String title,
      required String date,
      required String description,
      required int duration,
      required String category})
      : _title = title,
        _date = date,
        _description = description,
        _duration = duration,
        _category = category;

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

  void setCategory(String newCategory) {
    this._category = newCategory;
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

  String getCategory() {
    return this._category;
  }

  @override
  String toString() {
    return '$_title, $_date, $_description, $_duration, $_category';
  }
}
