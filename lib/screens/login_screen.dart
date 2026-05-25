import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../services/auth_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';
import 'beranda_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _prodiController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final auth = Provider.of<AuthService>(context, listen: false);
      final success = await auth.loginMahasiswa(
        nama: _namaController.text,
        nim: _nimController.text,
        prodi: _prodiController.text,
      );
      setState(() => _isLoading = false);
      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BerandaScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Data tidak valid! Periksa kembali Nama, NIM, dan Prodi Anda'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.blue.shade400,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // ================= LOGO LINGKARAN =================
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Efek glow di belakang logo
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        // Logo
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.cyan.shade300,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo aslab putih.png',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.blue, Colors.cyan],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'UMSIDA',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ================= TEKS SELAMAT DATANG =================
                  const Text(
                    'Laboratorium Informatika',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Universitas Muhammadiyah Sidoarjo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ================= KARTU LOGIN (GLASSMORPHISM) =================
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Login Mahasiswa',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Silakan masukkan data akademik Anda',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _namaController,
                                      label: 'Nama Lengkap',
                                      hint: 'Contoh: Ahmad Faiz',
                                      prefixIcon: Icons.person_outline,
                                      validator: (v) => v == null || v.isEmpty
                                          ? 'Nama tidak boleh kosong'
                                          : null,
                                    ),
                                    const SizedBox(height: 18),
                                    CustomTextField(
                                      controller: _nimController,
                                      label: 'NIM',
                                      hint: 'Masukkan NIM Anda',
                                      prefixIcon: Icons.numbers_outlined,
                                      keyboardType: TextInputType.number,
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return 'NIM tidak boleh kosong';
                                        }
                                        if (v.length < 8) {
                                          return 'NIM tidak valid';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    CustomTextField(
                                      controller: _prodiController,
                                      label: 'Program Studi',
                                      hint: 'Contoh: Informatika',
                                      prefixIcon: Icons.school_outlined,
                                      validator: (v) => v == null || v.isEmpty
                                          ? 'Program Studi tidak boleh kosong'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              _isLoading
                                  ? const Center(child: LoadingWidget())
                                  : Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.blue, Colors.cyan],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: _handleLogin,
                                        child: const Text(
                                          'Masuk ke Dashboard',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.blue.shade900,
                                        title: const Text(
                                          'Informasi Login',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: const Text(
                                          'Pastikan data yang Anda masukkan sesuai dengan data registrasi akademik.\n\n'
                                          'Jika gagal, hubungi admin ASLAB di ICT Center.',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.cyan,
                                            ),
                                            child: const Text('Tutup'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Butuh bantuan?',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '© 2026 Laboratorium Informatika UMSIDA',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
