import 'package:devcare_frontend/model/response/UserResponse.dart';

class EmailSentResponse {
  String? status;
  String? message;
  List<EmergencyContacts>? emergencyContacts;

  EmailSentResponse({this.status, this.message, this.emergencyContacts});

  EmailSentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['emergencyContacts'] != null) {
      emergencyContacts = <EmergencyContacts>[];
      json['emergencyContacts'].forEach((v) {
        emergencyContacts!.add(new EmergencyContacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.emergencyContacts != null) {
      data['emergencyContacts'] =
          this.emergencyContacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}