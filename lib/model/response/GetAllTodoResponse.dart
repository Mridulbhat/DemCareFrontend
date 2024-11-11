import 'Todos.dart';

class GetAllTodoResponse {
  String? status;
  List<Todos>? todos;

  GetAllTodoResponse({this.status, this.todos});

  GetAllTodoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['todos'] != null) {
      todos = <Todos>[];
      json['todos'].forEach((v) {
        todos!.add(new Todos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.todos != null) {
      data['todos'] = this.todos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

