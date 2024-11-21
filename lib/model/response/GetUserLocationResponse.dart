import 'package:devcare_frontend/model/response/UserResponse.dart';

class GetUserLocationResponse {
  String? status;
  PermanentLocation? permanentLocation;

  GetUserLocationResponse({this.status, this.permanentLocation});

  GetUserLocationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    permanentLocation = json['permanentLocation'] != null
        ? new PermanentLocation.fromJson(json['permanentLocation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.permanentLocation != null) {
      data['permanentLocation'] = this.permanentLocation!.toJson();
    }
    return data;
  }
}

