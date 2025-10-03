import 'package:flutter/material.dart';
import 'package:trying_flutter/services/api_services.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  AuthResponse? _authResponse;
  UserResponse? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  int? _userId;

  AuthResponse? get authResponse => _authResponse;
  UserResponse? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authResponse != null && _token != null;
  String? get token => _token;
  int? get userId => _userId;

  // Iniciar sesión
  Future<bool> signIn(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = SignInRequest(
        username: username,
        password: password,
      );

      _authResponse = await _apiService.signIn(request);
      
      // Guardar token y userId en memoria
      _token = _authResponse!.token;
      _userId = _authResponse!.id;
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Registrar usuario
  Future<bool> signUp(String username, String password, String role) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = SignUpRequest(
        username: username,
        password: password,
        role: role,
      );

      _currentUser = await _apiService.signUp(request);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    _authResponse = null;
    _currentUser = null;
    _token = null;
    _userId = null;
    notifyListeners();
  }
}