import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/model/body/OtpVerificationBody.dart';
import 'package:devcare_frontend/model/body/SignupBody.dart';
import 'package:devcare_frontend/model/response/OtpVerificationResponse.dart';
import 'package:devcare_frontend/model/response/SignupResponse.dart';
import 'package:devcare_frontend/model/response/UpdateEmergencyContactsResponse.dart';
import 'package:devcare_frontend/repository/authRepo.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SignupViewModel extends ChangeNotifier {
  AuthRepository _authRepository = new AuthRepository();

  // Define variables to store form data
  String name = '';
  String age = '';
  String gender = 'Male'; // Default value
  String email = '';
  String contact = '';

  String otpEntered = '';

  LatLng userLocation = LatLng(0.0, 0.0);

  updateLocation(LatLng newLocation) async {
    userLocation = newLocation;
    String address =
        await getAddressfromLatLng(newLocation.latitude, newLocation.longitude);
    setUserAddress(address);
    notifyListeners();
  }

  // List of options for the "Sex" dropdown
  final List<String> genderOptions = ['Male', 'Female', 'Other'];

  String? emergencyContactName1;
  String? emergencyContactNumber1;
  String? emergencyContactEmail1;
  String? emergencyContactName2;
  String? emergencyContactNumber2;
  String? emergencyContactEmail2;
  String? userAddress;

  void setEmergencyContactName1(String name) {
    emergencyContactName1 = name;
  }

  void setEmergencyContactNumber1(String number) {
    emergencyContactNumber1 = number;
  }

  void setEmergencyContactEmail1(String email) {
    emergencyContactEmail1 = email;
  }

  void setEmergencyContactName2(String name) {
    emergencyContactName2 = name;
  }

  void setEmergencyContactNumber2(String number) {
    emergencyContactNumber2 = number;
  }

  void setEmergencyContactEmail2(String email) {
    emergencyContactEmail2 = email;
  }

  void setUserAddress(String address) {
    userAddress = address;
    notifyListeners();
  }

  final Location location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Future<String> getAddressfromLatLng(double latitude, double longitude) async {
    String address = '';
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      geocoding.Placemark place = placemarks.first;
      address =
          "${place.name}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}";
    }

    return address;
  }

  Future<bool> getUserLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) return false;
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) return false;
      }

      LocationData userLocationData = await location.getLocation();
      updateLocation(LatLng(
          userLocationData.latitude ?? 0.0, userLocationData.longitude ?? 0.0));

      return true;
    } catch (e) {
      print(e);
      return false;
    }
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
      ApiResponse<SignupResponse>.preCall();
  ApiResponse<SignupResponse> get signupResponse => _signupResponse;

  ApiResponse<SignupResponse> _loginResponse =
      ApiResponse<SignupResponse>.preCall();
  ApiResponse<SignupResponse> get loginResponse => _loginResponse;

  ApiResponse<OTPVerificationResponse> _otpVerificationResponse =
      ApiResponse<OTPVerificationResponse>.preCall();
  ApiResponse<OTPVerificationResponse> get otpVerificationResponse =>
      _otpVerificationResponse;

  ApiResponse<UpdateEmergencyContactsResponse>
      _updateEmergencyContactsResponse =
      ApiResponse<UpdateEmergencyContactsResponse>.preCall();
  ApiResponse<UpdateEmergencyContactsResponse>
      get updateEmergencyContactsResponse => _updateEmergencyContactsResponse;

  // Function to make API call
  Future<ApiResponse<SignupResponse>> submitForm(SharedPrefs userPreference) async {
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
      userPreference.saveIsUserNew(true);
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

    dynamic body = {"email": email};

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
        otpEntered: otpEntered,
        otpId: _signupResponse.data?.otpId ?? _loginResponse.data?.otpId ?? '');

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
            "contactEmail": emergencyContactEmail1,
          },
          {
            "contactName": emergencyContactName2,
            "contactNumber": emergencyContactNumber2,
            "contactEmail": emergencyContactEmail2,
          },
        ],
        "permanentLocation": {"latitude": userLocation.latitude, "longitude": userLocation.longitude}
      };

      String token = await userPreference.getToken();

      await _authRepository
          .updateEmergencyContactsUrl(body, token)
          .then((value) {
        _updateEmergencyContactsResponse = ApiResponse.completed(value);
        userPreference.saveIsUserNew(false);
        notifyListeners();
      }).catchError((error) {
        _updateEmergencyContactsResponse = ApiResponse.error(error.toString());
        userPreference.saveIsUserNew(true);
        notifyListeners();
      });
    } catch (e) {
      _updateEmergencyContactsResponse = ApiResponse.error(e.toString());
        userPreference.saveIsUserNew(true);
      print('Error: $e');
    }

    return _updateEmergencyContactsResponse;
  }
}
