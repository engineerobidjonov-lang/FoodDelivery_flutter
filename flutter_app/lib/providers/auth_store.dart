import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthStore with ChangeNotifier {
  String? _token;
  String? _userName;
  bool _isLoading = false;

  String? get token => _token;
  String? get userName => _userName;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthStore() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userName = prefs.getString('userName');
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final result = await ApiService.login(email, password);
      if (result['token'] != null) {
        _token = result['token'];
        _userName = result['name'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('userName', _userName!);
        _isLoading = false;
        notifyListeners();
        return result;
      }
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Login Error: $e');
      _isLoading = false;
      notifyListeners();
      return {'error': {'message': 'An unexpected error occurred'}};
    }
  }

  Future<void> logout() async {
    _token = null;
    _userName = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userName');
    notifyListeners();
  }
}
