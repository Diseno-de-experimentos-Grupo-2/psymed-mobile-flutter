// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  // Cambia esta URL por la de tu backend
  static const String baseUrl = 'http://tu-servidor.com/api/v1';
  
  // Para emulador Android usa: http://10.0.2.2:puerto/api/v1
  // Para emulador iOS usa: http://localhost:puerto/api/v1
  // Para dispositivo físico usa tu IP local: http://192.168.x.x:puerto/api/v1

  // Sign Up - Registro de usuario
  Future<UserResponse> signUp(SignUpRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/sign-up'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al registrar usuario: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Sign In - Inicio de sesión
  Future<AuthResponse> signIn(SignInRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authentication/sign-in'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Credenciales inválidas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear perfil de paciente
  Future<PatientProfile> createPatientProfile(PatientProfileRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patient-profiles'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return PatientProfile.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al crear perfil: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener cuenta por ID
  Future<UserResponse> getAccount(int accountId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener cuenta');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener perfil de paciente por accountId
  Future<PatientProfile> getPatientProfileByAccount(int accountId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patient-profiles/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return PatientProfile.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al obtener perfil');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}