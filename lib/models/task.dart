class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      this.color,
      this.date,
      this.endTime,
      this.isCompleted,
      this.note,
      this.remind,
      this.repeat,
      this.startTime,
      this.title});
  Task.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    note = json["note"];
    isCompleted = json["isCompleted"];
    date = json["date"];
    startTime = json["startTime"];
    endTime = json["endTime"];
    color = json["color"];
    remind = json["remind"];
    repeat = json["repeat"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> date = <String, dynamic>{};
    date["id"] = id;
    date["title"] = title;
    date["note"] = note;
    date["isCompleted"] = isCompleted;
    date["date"] = date;
    date["startTime"] = startTime;
    date["endDate"] = endTime;
    date["color"] = color;
    date["remind"] = remind;
    date["repeat"] = repeat;

    return date;
  } // Convert a Cat into a Map. The keys must correspond to the names of the

  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }
}
