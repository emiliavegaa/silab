import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final SharedPreferences prefs;
  User? _currentUser;

  AuthService(this.prefs) {
    _loadUserFromPrefs();
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void _loadUserFromPrefs() {
    final id = prefs.getString('user_id');
    final nama = prefs.getString('user_nama');
    final nim = prefs.getString('user_nim');
    final prodi = prefs.getString('user_prodi');

    if (nama != null && nim != null && prodi != null && id != null) {
      _currentUser = User(
        id: id,
        nama: nama,
        nim: nim,
        prodi: prodi,
      );
    }
  }

  Future<bool> loginMahasiswa({
    required String nama,
    required String nim,
    required String prodi,
  }) async {
    // Simulasi validasi
    await Future.delayed(const Duration(seconds: 1));

    if (nama.isNotEmpty && nim.isNotEmpty && prodi.isNotEmpty && nim.length >= 8) {
      _currentUser = User(
        id: nim, // gunakan NIM sebagai ID
        nama: nama,
        nim: nim,
        prodi: prodi,
      );

      await prefs.setString('user_id', nim);
      await prefs.setString('user_nama', nama);
      await prefs.setString('user_nim', nim);
      await prefs.setString('user_prodi', prodi);
      await prefs.setBool('is_logged_in', true);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    await prefs.clear();
    notifyListeners();
  }
}