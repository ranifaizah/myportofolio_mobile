import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/screens/login_page.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

/// Memastikan pengguna sudah login sebelum membuka halaman tertentu.
Future<bool> ensureLoggedIn(BuildContext context) async {
  // Jika sudah login, langsung izinkan.
  if (context.read<AuthState>().isLoggedIn) {
    return true;
  }

  // Jika belum login, tampilkan halaman login.
  final loggedIn = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );

  return loggedIn ?? false;
}
