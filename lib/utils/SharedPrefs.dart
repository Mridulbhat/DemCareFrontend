import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs with ChangeNotifier {
  Future<bool> saveToken(String token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', token.toString());
    notifyListeners();
    return true;
  }

  Future<bool> saveIsUserNew(bool value) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('isUserNew', value.toString());
    notifyListeners();
    return true;
  }

  Future<String> getToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') ?? '';
  }

  Future<String> getIsUserNew() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('isUserNew') ?? 'true';
  }

  Future<Map> getAllValues() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return {
      'token': sp.getString('token') ?? '',
      'isUserNew': sp.getString('isUserNew') ?? 'true',
    };
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }
}