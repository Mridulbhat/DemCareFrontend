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
      this.todos});

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
    return data;
  }
}

class EmergencyContacts {
  String? contactName;
  String? contactNumber;
  String? sId;

  EmergencyContacts({this.contactName, this.contactNumber, this.sId});

  EmergencyContacts.fromJson(Map<String, dynamic> json) {
    contactName = json['contactName'];
    contactNumber = json['contactNumber'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactName'] = this.contactName;
    data['contactNumber'] = this.contactNumber;
    data['_id'] = this.sId;
    return data;
  }
}
