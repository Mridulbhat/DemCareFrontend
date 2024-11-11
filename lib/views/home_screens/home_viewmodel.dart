import 'dart:async';

import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/model/response/GetAllTodoResponse.dart';
import 'package:devcare_frontend/model/response/Todos.dart';
import 'package:devcare_frontend/repository/todoRepo.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class HomeViewModel extends ChangeNotifier {
  TodoRepository _todoRepository = new TodoRepository();

  Map<String, List<Todos>> _groupedTodos = {};
  Map<String, List<Todos>> get groupedTodos => _groupedTodos;

  ApiResponse<GetAllTodoResponse> _getAllTodoResponse =
      ApiResponse<GetAllTodoResponse>.loading();
  ApiResponse<GetAllTodoResponse> get getAllTodoResponse => _getAllTodoResponse;

  Future<ApiResponse<GetAllTodoResponse>> fetchUserTodos(
      SharedPrefs userPreference) async {
    print("Fetching todos for the user...");
    _getAllTodoResponse = ApiResponse.loading();
    _groupedTodos = {};

    try {
      String token = await userPreference.getToken();

      // Call repository method to fetch todos
      await _todoRepository.getAllTodos(token).then((value) {
        _getAllTodoResponse = ApiResponse.completed(value);

        List<Todos> todos = _getAllTodoResponse.data!.todos!;
        // Sort by date in descending order
        todos.sort((b, a) => DateTime.parse(b.scheduledFor.toString())
            .compareTo(DateTime.parse(a.scheduledFor.toString())));

        for (var todo in todos) {
          String dateKey = DateFormat.yMMMd().format(
              DateTime.parse(todo.scheduledFor.toString())
                  .add(Duration(hours: 5, minutes: 30)));

          print("GMT");
          print(todo.scheduledFor.toString());
          print("ISO");
          print(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(
              DateTime.parse(todo.scheduledFor.toString())
                  .add(Duration(hours: 5, minutes: 30))));
          if (!_groupedTodos.containsKey(dateKey)) {
            _groupedTodos[dateKey] = [];
          }
          _groupedTodos[dateKey]?.add(todo);
        }

        notifyListeners();
      }).catchError((error) {
        _getAllTodoResponse = ApiResponse.error(error.toString());
        notifyListeners();
      });
    } catch (e) {
      _getAllTodoResponse = ApiResponse.error(e.toString());
      print('Error: $e');
    }

    return _getAllTodoResponse;
  }

  Future<void> toggleTodoStatus(Todos todo, SharedPrefs userPreference) async {
    bool newStatus = !(todo.isDone ?? false);
    todo.isDone = newStatus;
    notifyListeners();

    try {
      print("Called");
      String token = await userPreference.getToken();
      dynamic data = {'isDone': newStatus};
      await _todoRepository
          .updateTodo(data, todo.sId.toString(), token)
          .then((value) async {
        await fetchUserTodos(userPreference);
      });
    } catch (e) {
      todo.isDone = !newStatus;
      notifyListeners();
    }
  }

  Future<void> addTodo(Todos newTodo, SharedPrefs userPreference) async {
    try {
      String token = await userPreference.getToken();
      await _todoRepository.addTodo(newTodo, token).then((value) async {
        await fetchUserTodos(userPreference);
      });

      notifyListeners();
    } catch (e) {
      print("Error adding to-do item: $e");
    }
  }
}
