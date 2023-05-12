import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userRole;
  String? _userId;

  Future<void> setToken(String token, String role, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('userId', userId);
    _token = token;
    _userRole = role;
    _userId = userId;
    notifyListeners();
  }

  Future<void> getStoredTokenAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userRole = prefs.getString('role');
    _userId = prefs.getString('userId');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('userId');
    _token = null;
    _userRole = null;
    _userId = null;
    notifyListeners();
  }

  String? get token => _token;
  String? get userRole => _userRole;
  String? get userId => _userId;

  bool get isAuthenticated => _token != null && _userRole != null;
}
