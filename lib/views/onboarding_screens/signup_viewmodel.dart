import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/model/body/OtpVerificationBody.dart';
import 'package:devcare_frontend/model/body/SignupBody.dart';
import 'package:devcare_frontend/model/response/OtpVerificationResponse.dart';
import 'package:devcare_frontend/model/response/SignupResponse.dart';
import 'package:devcare_frontend/model/response/UpdateEmergencyContactsResponse.dart';
import 'package:devcare_frontend/repository/authRepo.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  AuthRepository _authRepository = new AuthRepository();

  // Define variables to store form data
  String name = '';
  String age = '';
  String gender = 'Male'; // Default value
  String email = '';
  String contact = '';

  String otpEntered = '';

  // List of options for the "Sex" dropdown
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  String? emergencyContactName1;
  String? emergencyContactNumber1;
  String? emergencyContactName2;
  String? emergencyContactNumber2;

  void setEmergencyContactName1(String name) {
    emergencyContactName1 = name;
  }

  void setEmergencyContactNumber1(String number) {
    emergencyContactNumber1 = number;
  }

  void setEmergencyContactName2(String name) {
    emergencyContactName2 = name;
  }

  void setEmergencyContactNumber2(String number) {
    emergencyContactNumber2 = number;
  }

  // Update data methods
  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setAge(String value) {
    age = value;
    notifyListeners();
  }

  void setGender(String? value) {
    gender = value ?? gender;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setContact(String value) {
    contact = value;
    notifyListeners();
  }

  void setOTPEntered(String value) {
    otpEntered = value;
    notifyListeners();
  }

  ApiResponse<SignupResponse> _signupResponse =
      ApiResponse<SignupResponse>.loading();
  ApiResponse<SignupResponse> get signupResponse => _signupResponse;

  ApiResponse<SignupResponse> _loginResponse =
      ApiResponse<SignupResponse>.loading();
  ApiResponse<SignupResponse> get loginResponse => _loginResponse;

  ApiResponse<OTPVerificationResponse> _otpVerificationResponse =
      ApiResponse<OTPVerificationResponse>.loading();
  ApiResponse<OTPVerificationResponse> get otpVerificationResponse =>
      _otpVerificationResponse;

  ApiResponse<UpdateEmergencyContactsResponse>
      _updateEmergencyContactsResponse =
      ApiResponse<UpdateEmergencyContactsResponse>.loading();
  ApiResponse<UpdateEmergencyContactsResponse>
      get updateEmergencyContactsResponse => _updateEmergencyContactsResponse;

  // Function to make API call
  Future<ApiResponse<SignupResponse>> submitForm() async {
    _signupResponse = ApiResponse.loading();

    SignupBody signupBody = SignupBody();
    signupBody.name = name;
    signupBody.age = age;
    signupBody.email = email;
    signupBody.gender = gender;
    signupBody.contact = contact;

    dynamic body = signupBody.toJson();

    try {
      SignupResponse value = await _authRepository.signupUrl(body);
      _signupResponse = ApiResponse.completed(value);
      print(_signupResponse.toString());
      notifyListeners();
    } catch (error) {
      _signupResponse = ApiResponse.error(error.toString());
      notifyListeners();
      print('Error: $error');
    }

    return _signupResponse;
  }

  Future<ApiResponse<SignupResponse>> login() async {
    _loginResponse = ApiResponse.loading();

    dynamic body = {
      "email": email
    };

    try {
      await _authRepository.loginUrl(body).then((value) {
        _loginResponse = ApiResponse.completed(value);
        notifyListeners();
      }).catchError((error) {
        _loginResponse = ApiResponse.error(error.toString());
        notifyListeners();
      });
    } catch (e) {
      _loginResponse = ApiResponse.error(e.toString());
      print('Error: $e');
    }

    return _loginResponse;
  }

  Future<ApiResponse<OTPVerificationResponse>> verifyOTP(
      SharedPrefs userPreference) async {
    _otpVerificationResponse = ApiResponse.loading();

    OTPVerificationBody otpVerificationBody = OTPVerificationBody(
        otpEntered: otpEntered, otpId: _signupResponse.data?.otpId ?? _loginResponse.data?.otpId ?? '');

    dynamic body = otpVerificationBody.toJson();

    try {
      OTPVerificationResponse value = await _authRepository.verifyOTPUrl(body);
      _otpVerificationResponse = ApiResponse.completed(value);
      print(value.token.toString());
      print(userPreference.saveToken(value.token.toString()));
      print(_otpVerificationResponse.toString());
      notifyListeners();
    } catch (error) {
      _otpVerificationResponse = ApiResponse.error(error.toString());
      notifyListeners();
      print('Error: $error');
    }

    print(_otpVerificationResponse.data.toString());
    return _otpVerificationResponse;
  }

  Future<ApiResponse<UpdateEmergencyContactsResponse>>
      submitEmergencyContactsForm(SharedPrefs userPreference) async {
        print("here");
    _updateEmergencyContactsResponse = ApiResponse.loading();

    try {
      dynamic body = {
        "emergencyContacts": [
          {
            "contactName": emergencyContactName1,
            "contactNumber": emergencyContactNumber1,
          },
          {
            "contactName": emergencyContactName2,
            "contactNumber": emergencyContactNumber2,
          },
        ]
      };

      String token = await userPreference.getToken();

      await _authRepository.updateEmergencyContactsUrl(body, token).then((value) {
        _updateEmergencyContactsResponse = ApiResponse.completed(value);
        notifyListeners();
      }).catchError((error) {
        _updateEmergencyContactsResponse = ApiResponse.error(error.toString());
        notifyListeners();
      });
    } catch (e) {
      _updateEmergencyContactsResponse = ApiResponse.error(e.toString());
      print('Error: $e');
    }

    return _updateEmergencyContactsResponse;
  }
}
