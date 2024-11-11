class AppUrl {
  static var baseUrl = 'http://192.168.1.13:5010/api';

  static var signupUrl = '$baseUrl/signup';
  static var loginUrl = '$baseUrl/login';
  static var verifyOtpUrl = '$baseUrl/otp-verify';
  static var updateEmergencyContactsUrl = '$baseUrl/update-emergency-contacts';

  static var addTodoUrl = '$baseUrl/user/todo/addTodo';
  static var getTodosUrl = '$baseUrl/user/todo/getAllTodo';
  static var updateTodoUrl = '$baseUrl/user/todo/updateTodo';
  static var deleteTodoUrl = '$baseUrl/user/todo/deleteTodo';
}
