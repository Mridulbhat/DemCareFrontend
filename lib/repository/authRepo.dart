import 'package:devcare_frontend/data/network/BaseApiServices.dart';
import 'package:devcare_frontend/data/network/NetworkApiServices.dart';
import 'package:devcare_frontend/model/response/OtpVerificationResponse.dart';
import 'package:devcare_frontend/model/response/SignupResponse.dart';
import 'package:devcare_frontend/model/response/UpdateEmergencyContactsResponse.dart';
import 'package:devcare_frontend/utils/AppUrl.dart';

class AuthRepository {
  final BaseApiServices _apiServices = NetworkApiServices();

  Future<SignupResponse> signupUrl(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.signupUrl, data);
      return response = SignupResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignupResponse> loginUrl(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.loginUrl, data);
      return response = SignupResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<OTPVerificationResponse> verifyOTPUrl(dynamic data) async {
    try {
      dynamic response =
          await _apiServices.getPostApiResponse(AppUrl.verifyOtpUrl, data);
      return response = OTPVerificationResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UpdateEmergencyContactsResponse> updateEmergencyContactsUrl(dynamic data, String token) async {
    try {
      dynamic response =
          await _apiServices.userPostApiResponse(AppUrl.updateEmergencyContactsUrl, data, token);
          print(response);
      return response = UpdateEmergencyContactsResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
