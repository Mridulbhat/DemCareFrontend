class Todos {
  String? title;
  String? description;
  bool? isDone;
  String? scheduledFor;
  String? sId;

  Todos(
      {this.title, this.description, this.isDone, this.scheduledFor, this.sId});

  Todos.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'];
    scheduledFor = json['scheduledFor'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['isDone'] = this.isDone;
    data['scheduledFor'] = this.scheduledFor;
    data['_id'] = this.sId;
    return data;
  }
}