import 'dart:async';
import 'dart:ffi';

import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/model/response/EmailSentResponse.dart';
import 'package:devcare_frontend/model/response/GetAllTodoResponse.dart';
import 'package:devcare_frontend/model/response/GetUserLocationResponse.dart';
import 'package:devcare_frontend/model/response/Todos.dart';
import 'package:devcare_frontend/repository/todoRepo.dart';
import 'package:devcare_frontend/repository/userRepo.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart'; // For formatting dates

class HomeViewModel extends ChangeNotifier {
  TodoRepository _todoRepository = new TodoRepository();
  UserRepository _userRepository = new UserRepository();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Map<String, List<Todos>> _groupedTodos = {};
  Map<String, List<Todos>> get groupedTodos => _groupedTodos;

  ApiResponse<GetAllTodoResponse> _getAllTodoResponse =
      ApiResponse<GetAllTodoResponse>.preCall();
  ApiResponse<GetAllTodoResponse> get getAllTodoResponse => _getAllTodoResponse;

  ApiResponse<GetUserLocationResponse> _getUserLocationResponse =
      ApiResponse<GetUserLocationResponse>.preCall();
  ApiResponse<GetUserLocationResponse> get getUserLocationResponse =>
      _getUserLocationResponse;

  ApiResponse<EmailSentResponse> _postEmailSentResponse =
      ApiResponse<EmailSentResponse>.preCall();
  ApiResponse<EmailSentResponse> get postEmailSentResponse =>
      _postEmailSentResponse;

  Future<ApiResponse<GetAllTodoResponse>> fetchUserTodos(
      SharedPrefs userPreference) async {
    print("Fetching todos for the user...");
    _getAllTodoResponse = ApiResponse.loading();
    _groupedTodos = {};

    try {
      String token = await userPreference.getToken();

      // Call repository method to fetch todos
      await _todoRepository.getAllTodos(token).then((value) {
        _getAllTodoResponse = ApiResponse.completed(value);

        List<Todos> todos = _getAllTodoResponse.data!.todos!;
        // Sort by date in descending order
        todos.sort((b, a) => DateTime.parse(b.scheduledFor.toString())
            .compareTo(DateTime.parse(a.scheduledFor.toString())));

        for (var todo in todos) {
          String dateKey = DateFormat.yMMMd().format(
              DateTime.parse(todo.scheduledFor.toString())
                  .add(Duration(hours: 5, minutes: 30)));

          print("GMT");
          print(todo.scheduledFor.toString());
          print("ISO");
          print(DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(
              DateTime.parse(todo.scheduledFor.toString())
                  .add(Duration(hours: 5, minutes: 30))));
          if (!_groupedTodos.containsKey(dateKey)) {
            _groupedTodos[dateKey] = [];
          }
          _groupedTodos[dateKey]?.add(todo);
        }

        notifyListeners();
      }).catchError((error) {
        _getAllTodoResponse = ApiResponse.error(error.toString());
        notifyListeners();
      });
    } catch (e) {
      _getAllTodoResponse = ApiResponse.error(e.toString());
      print('Error: $e');
    }

    return _getAllTodoResponse;
  }

  Future<void> toggleTodoStatus(Todos todo, SharedPrefs userPreference) async {
    bool newStatus = !(todo.isDone ?? false);
    todo.isDone = newStatus;
    notifyListeners();

    try {
      print("Called");
      String token = await userPreference.getToken();
      dynamic data = {'isDone': newStatus};
      await _todoRepository
          .updateTodo(data, todo.sId.toString(), token)
          .then((value) async {
        await fetchUserTodos(userPreference);
      });
    } catch (e) {
      todo.isDone = !newStatus;
      notifyListeners();
    }
  }

  Future<void> addTodo(Todos newTodo, SharedPrefs userPreference) async {
    try {
      String token = await userPreference.getToken();
      await _todoRepository.addTodo(newTodo, token).then((value) async {
        await fetchUserTodos(userPreference);
      });

      notifyListeners();
    } catch (e) {
      print("Error adding to-do item: $e");
    }
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'launch_background'); // Add your app icon in android/app/src/main/res/drawable
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotificationWithEmergencyOptions() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'distance_alert', // Channel ID
      'Distance Alert', // Channel Name
      channelDescription: 'Notification when distance exceeds threshold',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound(
      //     'alarm'), // Add your alarm sound in android/app/src/main/res/raw
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Distance Alert',
      'You are more than 3 km away from your set location!',
      platformChannelSpecifics,
      payload: 'emergency_action',
    );
  }

  double? _distanceInKiloMeters;
  double? get distanceInKiloMeters => _distanceInKiloMeters;

  bool emergencyEmailsSent = false;

  void setEmergencyEmailsSent(bool value) {
    emergencyEmailsSent = value;
    notifyListeners();
  }

  late Timer _timer;

  Future<void> fetchAndCalculateDistance(SharedPrefs userPreference) async {
    try {
      print('Called Distance Cal');
      // _initializeNotifications();
      _getUserLocationResponse = ApiResponse.loading();
      String token = await userPreference.getToken();

      // Fetch permanent location from backend
      await _userRepository
          .getLocation(token)
          .then((value) => {
                _getUserLocationResponse = ApiResponse.completed(value),
                notifyListeners(),
              })
          .catchError((error) {
        _getUserLocationResponse = ApiResponse.error(error.toString());
        notifyListeners();
        return Void;
      });

      print('Got permanent coordinates');
      print(_getUserLocationResponse.data!.permanentLocation!.latitude);
      print(_getUserLocationResponse.status);

      if (_getUserLocationResponse.status == Status.COMPLETED) {
        print('Calculating distance...');
        LocationData currentLocation = await _getCurrentLocation();
        print(currentLocation.latitude);
        _distanceInKiloMeters = Geolocator.distanceBetween(
              _getUserLocationResponse.data!.permanentLocation!.latitude!,
              _getUserLocationResponse.data!.permanentLocation!.longitude!,
              currentLocation.latitude ?? 0.0,
              currentLocation.longitude ?? 0.0,
            ) /
            1000;
        _distanceInKiloMeters = (_distanceInKiloMeters! * 100).round() / 100;
        print(_distanceInKiloMeters);
        notifyListeners();
        if (_distanceInKiloMeters! > 3.0) {
          print('Distance exceeds 3 km: Triggering alarm');
          dynamic data = {
            'message':
                'I am ${_distanceInKiloMeters} km away from my home at the following location: Latitude ${currentLocation.latitude}, Longitude ${currentLocation.longitude}. Please check on me.'
          };
          _postEmailSentResponse = ApiResponse.loading();
          await _userRepository
              .sendEmergencyEmails(token, data)
              .then((value) => {
                    setEmergencyEmailsSent(true),
                    print(value.toString()),
                    _postEmailSentResponse = ApiResponse.completed(value),
                    notifyListeners(),
                  })
              .catchError((error) {
            _postEmailSentResponse = ApiResponse.error(error);
            print(error);
          });
          // _showNotificationWithEmergencyOptions();
        } else {
          setEmergencyEmailsSent(false);
          notifyListeners();
        }
        _timer = Timer.periodic(Duration(hours: 1), (timer) async {
          print('Calculating distance...');
          LocationData currentLocation = await _getCurrentLocation();
          print(currentLocation.latitude);
          _distanceInKiloMeters = Geolocator.distanceBetween(
                _getUserLocationResponse.data!.permanentLocation!.latitude!,
                _getUserLocationResponse.data!.permanentLocation!.longitude!,
                currentLocation.latitude ?? 0.0,
                currentLocation.longitude ?? 0.0,
              ) /
              1000;
          _distanceInKiloMeters = (_distanceInKiloMeters! * 100).round() / 100;
          print(_distanceInKiloMeters);
          notifyListeners();
          if (_distanceInKiloMeters! > 3.0) {
            print('Distance exceeds 3 km: Triggering alarm');
            dynamic data = {
              'message':
                  'I am ${_distanceInKiloMeters} km away from my home at the following location: Latitude ${currentLocation.latitude}, Longitude ${currentLocation.longitude}. Please check on me.'
            };
            _postEmailSentResponse = ApiResponse.loading();
            await _userRepository
                .sendEmergencyEmails(token, data)
                .then((value) => {
                      setEmergencyEmailsSent(true),
                      _postEmailSentResponse = ApiResponse.completed(value),
                      notifyListeners(),
                    })
                .catchError((error) {
              _postEmailSentResponse = ApiResponse.error(error);
              print(error);
            });
            // _showNotificationWithEmergencyOptions();
          } else {
            setEmergencyEmailsSent(false);
            notifyListeners();
          }
        });
      }
    } catch (e) {
      print("Error fetching or calculating distance: $e");
    }
  }

  Future<LocationData> _getCurrentLocation() async {
    final Location location = Location();
    bool _serviceEnabled = false;
    PermissionStatus _permissionGranted = PermissionStatus.denied;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) throw Exception('Error fetching current location');
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted)
        throw Exception('Error fetching current location');
    }

    LocationData userLocationData = await location.getLocation();

    return userLocationData;
  }

  bool animateMicButton = false;
  setAnimateMicButton(bool value) {
    animateMicButton = value;
    notifyListeners();
  }

  String recogText = "";
  String displayText = "";
  setRecogText(String value) {
    print(value);
    recogText = value;
    notifyListeners();
  }

  setDisplaytext() {
    if (recogText != "") {
      displayText = displayText + "\n" + recogText;
      recogText = "";
      notifyListeners();
    }
  }

  nullDisplayText() {
    displayText = "";
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel(); // Clean up timer
    super.dispose();
  }
}
