import 'package:devcare_frontend/data/network/BaseApiServices.dart';
import 'package:devcare_frontend/data/network/NetworkApiServices.dart';
import 'package:devcare_frontend/model/response/EmailSentResponse.dart';
import 'package:devcare_frontend/model/response/GetUserLocationResponse.dart';
import 'package:devcare_frontend/utils/AppUrl.dart';

class UserRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<GetUserLocationResponse> getLocation(String token) async {
    try {
      dynamic response = await _apiServices.userGetApiResponse(
        AppUrl.getUserLocation,
        token,
      );
      return GetUserLocationResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<EmailSentResponse> sendEmergencyEmails(String token, dynamic data) async {
    try {
      dynamic response = await _apiServices.userPostApiResponse(
        AppUrl.sendEmergencyEmail,
        data,
        token,
      );
      return EmailSentResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
