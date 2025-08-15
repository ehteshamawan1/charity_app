import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  final ApiService _apiService = ApiService();

  Future<bool> login(String cnic, String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        cnic: cnic,
        phoneNumber: phoneNumber,
        location: 'Karachi',
        role: UserRole.donor,
        isVerified: true,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String cnic,
    required String phoneNumber,
    required String location,
    required UserRole role,
    Map<String, dynamic>? additionalInfo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (!_validateCNIC(cnic)) {
        throw Exception('Invalid CNIC format');
      }
      
      if (!_validatePhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }
      
      _currentUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        cnic: cnic,
        phoneNumber: phoneNumber,
        location: location,
        role: role,
        isVerified: false,
        additionalInfo: additionalInfo,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool _validateCNIC(String cnic) {
    final regex = RegExp(r'^\d{5}-\d{7}-\d$');
    return regex.hasMatch(cnic);
  }

  bool _validatePhoneNumber(String phone) {
    final regex = RegExp(r'^\+92\d{10}$');
    return regex.hasMatch(phone);
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
}