// lib/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:vienna_airport_taxi/data/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;
  bool get isAuthenticated => _authService.currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initialize auth state
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (await _authService.isLoggedIn()) {
        // User is already logged in, no need to notify again
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.login(email, password);
      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Invalid email or password';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    String? address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );
      if (success) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Registration failed. Please check your information.';
      }
      return success;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    await _authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
      address: address,
    );
    notifyListeners();
  }
}
