import 'package:devcare_frontend/model/response/UserResponse.dart';

class UpdateEmergencyContactsResponse {
  String? status;
  String? message;
  User? user;

  UpdateEmergencyContactsResponse({this.status, this.message, this.user});

  UpdateEmergencyContactsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}