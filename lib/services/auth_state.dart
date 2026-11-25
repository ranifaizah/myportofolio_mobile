import 'package:flutter/foundation.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._apiClient);

  final ApiClient _apiClient;

  String? _token;

  // Mengambil token pengguna
  String? get token => _token;

  // Memeriksa apakah pengguna sudah login
  bool get isLoggedIn => _token != null;

  // Login menggunakan Django
  Future<void> login(String username, String password) async {
    _token = await _apiClient.obtainToken(username, password);

    notifyListeners();
  }

  // Logout dan menghapus token dari aplikasi
  Future<void> logout() async {
    _token = null;
    notifyListeners();
  }
}
