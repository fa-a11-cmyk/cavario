import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;
  String? _currentUserName;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserId = prefs.getString('currentUserId');
    _currentUserName = prefs.getString('currentUserName');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Simulation d'authentification
    if (email == 'admin@cavario.com' && password == 'admin123') {
      _isAuthenticated = true;
      _currentUserId = '1';
      _currentUserName = 'Admin';
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('currentUserId', _currentUserId!);
      await prefs.setString('currentUserName', _currentUserName!);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserId = null;
    _currentUserName = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}