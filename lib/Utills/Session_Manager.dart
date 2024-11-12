import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nirmiti_app/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class SessionManager with ChangeNotifier {
  Timer? _timer;
  bool _isTokenValid = false;
  static saveUserObject(User_Registration user) async {
    var key = 'user';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_user_login', true);

    final userJson = jsonEncode(user.toJson());
    await prefs.get(user.employee_id.toString());

    await prefs.setString(key, userJson);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bearer_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bearer_token');
  }

  Future<void> saveTokenTimer(String token, var expiryTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bearerToken', token);
    await prefs.setInt('expiryTime', expiryTime);
    final expirationTime = DateTime.now()
        .add(Duration(seconds: expiryTime))
        .millisecondsSinceEpoch;
    await prefs.setInt('expirationTime', expirationTime);

    // Start the timer
    _isTokenValid = true;
    notifyListeners();
    _startTimer(expiryTime);
  }

  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimeStr = prefs.getInt('expiryTime');
    Timer(Duration(seconds: 60), () {
      expiryTimeStr == null;
    });
    if (expiryTimeStr == null) {
      return true; // Token does not exist or expiration time not set
    }

    return false;
  }

  void _startTimer(int durationInSeconds) {
    _timer = Timer(Duration(seconds: durationInSeconds), () {
      // Timer expired, clear token
      //clearToken();
    });
  }

  static Future<User_Registration> getUser() async {
    var key = 'user';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      Map<String, dynamic> map = jsonDecode(prefs.getString(key).toString());
      return User_Registration.fromJson(map);
    } else
      return User_Registration();
  }

  static Future<bool> isUserLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('is_user_login');
  }

  static Future<Object?> isUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get('user_id');
  }

  static logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
