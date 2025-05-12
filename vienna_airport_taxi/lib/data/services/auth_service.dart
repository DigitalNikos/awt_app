// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? address;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String?,
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  User? _currentUser;

  // Get current user
  User? get currentUser => _currentUser;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);

    if (token != null) {
      // Load user data if not already loaded
      if (_currentUser == null) {
        await _loadUserData();
      }
      return true;
    }
    return false;
  }

  // Load user data from shared preferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      _currentUser = User.fromJson(userData);
    }
  }

  // Save user data to shared preferences
  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    // Simulate network request delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, accept any email with a valid format and any password
    if (email.contains('@') && password.length >= 6) {
      _currentUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@')[0],
        email: email,
        phone: '+43 123 456 7890', // Default phone for demo
      );

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _authTokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');
      await _saveUserData();

      return true;
    }

    return false;
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? address,
  }) async {
    // Simulate network request delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, accept any email with a valid format and any password
    if (name.isNotEmpty &&
        email.contains('@') &&
        password.length >= 6 &&
        phone.isNotEmpty) {
      _currentUser = User(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _authTokenKey, 'demo-token-${DateTime.now().millisecondsSinceEpoch}');
      await _saveUserData();

      return true;
    }

    return false;
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove('saved_address');
  }

  // Save user address
  Future<void> saveAddress(String address) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(address: address);
      await _saveUserData();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_address', address);
    }
  }

  // Get saved address
  Future<String?> getSavedAddress() async {
    if (_currentUser?.address != null) {
      return _currentUser!.address;
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_address');
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        email: email ?? _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        address: address ?? _currentUser!.address,
      );
      await _saveUserData();
    }
  }
}
