import 'dart:ffi';

import 'package:devcare_frontend/model/response/Todos.dart';

class User {
  String? sId;
  String? name;
  int? age;
  String? gender;
  String? email;
  String? contact;
  bool? verified;
  String? createdAt;
  List<EmergencyContacts>? emergencyContacts;
  String? updatedAt;
  int? iV;
  List<Todos>? todos;
  PermanentLocation? permanentLocation;

  User(
      {this.sId,
      this.name,
      this.age,
      this.gender,
      this.email,
      this.contact,
      this.verified,
      this.createdAt,
      this.emergencyContacts,
      this.updatedAt,
      this.iV,
      this.todos,
      this.permanentLocation});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    email = json['email'];
    contact = json['contact'];
    verified = json['verified'];
    createdAt = json['createdAt'];
    if (json['emergencyContacts'] != null) {
      emergencyContacts = <EmergencyContacts>[];
      json['emergencyContacts'].forEach((v) {
        emergencyContacts!.add(new EmergencyContacts.fromJson(v));
      });
    }
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['todos'] != null) {
      todos = <Todos>[];
      json['todos'].forEach((v) {
        todos!.add(new Todos.fromJson(v));
      });
    }
    permanentLocation = PermanentLocation.fromJson(json['permanentLocation']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['verified'] = this.verified;
    data['createdAt'] = this.createdAt;
    if (this.emergencyContacts != null) {
      data['emergencyContacts'] =
          this.emergencyContacts!.map((v) => v.toJson()).toList();
    }
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.todos != null) {
      data['todos'] = this.todos!.map((v) => v.toJson()).toList();
    }
    data['permanentLocation'] = this.permanentLocation!.toJson();
    return data;
  }
}

class EmergencyContacts {
  String? contactName;
  String? contactNumber;
  String? contactEmail;
  String? sId;

  EmergencyContacts({this.contactName, this.contactNumber, this.contactEmail, this.sId});

  EmergencyContacts.fromJson(Map<String, dynamic> json) {
    contactName = json['contactName'];
    contactNumber = json['contactNumber'];
    contactEmail = json['contactEmail'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactName'] = this.contactName;
    data['contactNumber'] = this.contactNumber;
    data['contactEmail'] = this.contactEmail;
    data['_id'] = this.sId;
    return data;
  }
}

class PermanentLocation {
  double? latitude;
  double? longitude;

  PermanentLocation({this.latitude, this.longitude});

  PermanentLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
