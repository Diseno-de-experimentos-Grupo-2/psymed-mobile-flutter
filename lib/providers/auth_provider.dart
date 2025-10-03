import 'package:flutter/material.dart';
import 'package:trying_flutter/services/api_services.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  AuthResponse? _authResponse;
  UserResponse? _currentUser;
  PatientProfile? _patientProfile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  int? _userId;

  AuthResponse? get authResponse => _authResponse;
  UserResponse? get currentUser => _currentUser;
  PatientProfile? get patientProfile => _patientProfile;
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
      
      // Cargar el perfil del usuario
      await _loadUserProfile();
      
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

  // Registrar usuario con perfil de paciente
  Future<bool> signUpWithProfile({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String email,
    required String street,
    required String city,
    required String country,
    required int professionalId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Crear el perfil de paciente (esto crea tanto la cuenta como el perfil)
      final profileRequest = PatientProfileRequest(
        firstName: firstName,
        lastName: lastName,
        street: street,
        city: city,
        country: country,
        email: email,
        username: username,
        password: password,
        professionalId: professionalId,
      );
      
      _patientProfile = await _apiService.createPatientProfile(profileRequest);
      
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

  // Cargar perfil del usuario
  Future<void> _loadUserProfile() async {
    if (_userId == null || _token == null) return;

    try {
      // Primero obtener los datos de la cuenta
      _currentUser = await _apiService.getAccount(_userId!, _token!);
      
      // Luego obtener el perfil de paciente
      _patientProfile = await _apiService.getPatientProfileByAccount(_userId!, _token!);
      
      notifyListeners();
    } catch (e) {
      print('Error al cargar perfil: $e');
      // No lanzamos error aquí porque el login fue exitoso
      // El perfil podría no existir aún
    }
  }

  // Recargar perfil (útil después de editar)
  Future<bool> reloadProfile() async {
    if (_userId == null || _token == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _loadUserProfile();
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
    _patientProfile = null;
    _token = null;
    _userId = null;
    notifyListeners();
  }
}