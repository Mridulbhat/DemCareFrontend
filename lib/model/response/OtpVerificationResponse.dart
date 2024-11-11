import 'package:devcare_frontend/model/response/UserResponse.dart';

class OTPVerificationResponse {
  String? status;
  User? user;
  String? token;
  String? message;

  OTPVerificationResponse({this.status, this.user, this.token, this.message});

  OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    data['message'] = this.message;
    return data;
  }
}