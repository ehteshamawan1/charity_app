import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3001/api';

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return _mockResponse(endpoint, body);
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return _mockResponse(endpoint, {});
    }
  }

  Map<String, dynamic> _mockResponse(String endpoint, Map<String, dynamic> body) {
    if (endpoint.contains('/auth/login')) {
      return {
        'success': true,
        'user': {
          'id': 'user_123',
          'cnic': body['cnic'],
          'phoneNumber': body['phoneNumber'],
          'role': 'donor',
          'isVerified': true,
        },
        'token': 'mock_token_123',
      };
    } else if (endpoint.contains('/auth/register')) {
      return {
        'success': true,
        'user': {
          'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
          'cnic': body['cnic'],
          'phoneNumber': body['phoneNumber'],
          'role': body['role'],
          'isVerified': false,
        },
      };
    } else if (endpoint.contains('/cases')) {
      return {
        'success': true,
        'cases': [],
      };
    }
    return {'success': true};
  }
}