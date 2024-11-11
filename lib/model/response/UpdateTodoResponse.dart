import 'package:devcare_frontend/model/response/Todos.dart';

class UpdateTodoResponse {
  String? status;
  Todos? todo;

  UpdateTodoResponse({this.status, this.todo});

  UpdateTodoResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    todo = json['todo'] != null ? new Todos.fromJson(json['todo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.todo != null) {
      data['todo'] = this.todo!.toJson();
    }
    return data;
  }
}