import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs with ChangeNotifier {
  Future<bool> saveToken(String token) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('token', token.toString());
    notifyListeners();
    return true;
  }

  Future<String> getToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('token') ?? '';
  }

  Future<bool> remove() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.clear();
  }
}