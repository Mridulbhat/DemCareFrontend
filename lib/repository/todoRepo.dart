import 'package:devcare_frontend/data/network/BaseApiServices.dart';
import 'package:devcare_frontend/data/network/NetworkApiServices.dart';
import 'package:devcare_frontend/model/response/AddTodoResponse.dart';
import 'package:devcare_frontend/model/response/GetAllTodoResponse.dart';
import 'package:devcare_frontend/model/response/UpdateTodoResponse.dart';
import 'package:devcare_frontend/model/response/DeleteTodoResponse.dart';
import 'package:devcare_frontend/utils/AppUrl.dart';

class TodoRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<AddTodoResponse> addTodo(dynamic data, String token) async {
    try {
      dynamic response = await _apiServices.userPostApiResponse(
        AppUrl.addTodoUrl, 
        data, 
        token,
      );
      return AddTodoResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetAllTodoResponse> getAllTodos(String token) async {
    try {
      dynamic response = await _apiServices.userGetApiResponse(
        AppUrl.getTodosUrl,
        token,
      );
      return GetAllTodoResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateTodoResponse> updateTodo(
    dynamic data,
    String todoId,
    String token,
  ) async {
    try {
      dynamic response = await _apiServices.userPatchApiResponse(
        "${AppUrl.updateTodoUrl}/$todoId",
        data,
        token,
      );
      return UpdateTodoResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<DeleteTodoResponse> deleteTodo(
    String todoId,
    String token,
  ) async {
    try {
      dynamic response = await _apiServices.userDeleteApiResponse(
        "${AppUrl.deleteTodoUrl}/$todoId",
        token,
      );
      return DeleteTodoResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
