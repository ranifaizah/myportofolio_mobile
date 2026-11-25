import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Alamat backend Django
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Login dan mendapatkan token
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/token/'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      throw Exception('Login gagal. Periksa username dan password.');
    }
  }

  // Mengambil daftar Experience
  static Future<List<dynamic>> getExperiences(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/experiences/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  }
}
