class AppUrl {
  static var baseUrl = 'http://192.168.206.103:5010/api';

  static var signupUrl = '$baseUrl/signup';
  static var loginUrl = '$baseUrl/login';
  static var verifyOtpUrl = '$baseUrl/otp-verify';
  static var updateEmergencyContactsUrl = '$baseUrl/update-profile';

  static var addTodoUrl = '$baseUrl/user/todo/addTodo';
  static var getTodosUrl = '$baseUrl/user/todo/getAllTodo';
  static var updateTodoUrl = '$baseUrl/user/todo/updateTodo';
  static var deleteTodoUrl = '$baseUrl/user/todo/deleteTodo';

  static var getUserLocation = '$baseUrl/user/location';
  static var sendEmergencyEmail = '$baseUrl/user/emergency/sendAlert';
}
