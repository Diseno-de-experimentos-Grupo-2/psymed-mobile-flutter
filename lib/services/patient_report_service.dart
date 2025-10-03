// lib/services/patient_report_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_report_model.dart';

class PatientReportService {
  static const String baseUrl = 'http://192.168.1.5:8080/api/v1';

  dynamic _parseResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception('El servidor no retornó datos. Status: ${response.statusCode}');
    }

    if (response.body.trim().startsWith('<')) {
      throw Exception('El servidor respondió con HTML en lugar de JSON.');
    }

    try {
      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error al parsear JSON: $e');
    }
  }

  // Obtener estados de ánimo del paciente
  Future<List<MoodState>> getMoodStates(int patientId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId/mood-states'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = _parseResponse(response);
        return data.map((json) => MoodState.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al obtener estados de ánimo');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al servidor.');
      }
      rethrow;
    }
  }

  // Crear estado de ánimo
  Future<MoodState> createMoodState(int patientId, MoodStateRequest request, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patients/$patientId/mood-states'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MoodState.fromJson(_parseResponse(response));
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al guardar estado de ánimo');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al servidor.');
      }
      rethrow;
    }
  }

  // Obtener funciones biológicas del paciente
  Future<List<BiologicalFunction>> getBiologicalFunctions(int patientId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patients/$patientId/biological-functions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = _parseResponse(response);
        return data.map((json) => BiologicalFunction.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return [];
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al obtener funciones biológicas');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al servidor.');
      }
      rethrow;
    }
  }

  // Crear funciones biológicas
  Future<BiologicalFunction> createBiologicalFunction(
    int patientId,
    BiologicalFunctionRequest request,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/patients/$patientId/biological-functions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BiologicalFunction.fromJson(_parseResponse(response));
      } else if (response.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al guardar funciones biológicas');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al servidor.');
      }
      rethrow;
    }
  }
}
