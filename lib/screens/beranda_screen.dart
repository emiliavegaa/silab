import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../services/auth_service.dart';
import 'peminjaman_lab_screen.dart';
import 'peminjaman_barang_screen.dart';
import 'jadwal_lab_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  void _showCekJadwalDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.blue.shade900,
        title: Row(children: const [
          Icon(Icons.info_outline, color: Colors.cyan),
          SizedBox(width: 10),
          Text('Cek Jadwal Lab', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
        ]),
        content: const Text(
          'Sebelum meminjam laboratorium, silakan cek jadwal terlebih dahulu.\n\nPastikan lab yang ingin dipinjam tersedia pada waktu yang Anda inginkan.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(ctx, MaterialPageRoute(builder: (_) => const PeminjamanLabScreen()));
            },
            child: const Text('Lanjutkan Peminjaman', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(ctx, MaterialPageRoute(builder: (_) => const JadwalLabScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Cek Jadwal', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPeraturanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.blue.shade900,
        title: const Text('Peraturan & Ketentuan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📋 Aturan Peminjaman Lab:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              Text('• Tidak menginstall game yang tidak berkaitan dengan perkuliahan', style: TextStyle(color: Colors.white70)),
              Text('• Menjaga kebersihan dan kenyamanan lab', style: TextStyle(color: Colors.white70)),
              Text('• Melaporkan kerusakan yang ditemukan', style: TextStyle(color: Colors.white70)),
              Text('• Kembalikan komputer dalam keadaan mati', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16),
              Text('🔧 Aturan Peminjaman Barang:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 8),
              Text('• Denda keterlambatan: Rp 2.000/jam', style: TextStyle(color: Colors.white70)),
              Text('• Harus mengembalikan barang dalam kondisi baik', style: TextStyle(color: Colors.white70)),
              Text('• Dokumentasi foto sebelum dan sesudah peminjaman', style: TextStyle(color: Colors.white70)),
              Text('• Konfirmasi kerusakan kepada admin ASLAB', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.cyan),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade900.withOpacity(0.8), Colors.blue.shade600.withOpacity(0.6)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: Colors.blue.shade900,
                  title: const Text('Konfirmasi Logout', style: TextStyle(color: Colors.white)),
                  content: const Text('Apakah Anda yakin ingin logout?', style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), style: TextButton.styleFrom(foregroundColor: Colors.white70), child: const Text('Batal')),
                    TextButton(onPressed: () { auth.logout(); Navigator.pushReplacementNamed(ctx, '/'); }, style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Logout')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.blue.shade700, Colors.blue.shade400],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Profil card dengan logo ASLAB
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: 90, height: 90, decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 20, spreadRadius: 5)])),
                        Container(
                          width: 75, height: 75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 3))],
                            border: Border.all(color: Colors.cyan.shade300, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo aslab putih.png',
                              width: 75, height: 75, fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 75, height: 75,
                                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.blue, Colors.cyan]), shape: BoxShape.circle),
                                child: const Center(child: Text('ASLAB', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1))),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.nama ?? 'Mahasiswa', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('NIM: ${user?.nim ?? '-'}', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                          Text('Prodi: ${user?.prodi ?? '-'}', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildMenuCard(context, 'Peminjaman Lab', 'Pinjam komputer lab', Icons.computer, () => _showCekJadwalDialog(context)),
                      _buildMenuCard(context, 'Peminjaman Barang', 'Pinjam perkakas lab', Icons.build, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PeminjamanBarangScreen()))),
                      _buildMenuCard(context, 'Cek Jadwal Lab', 'Lihat jadwal lab', Icons.calendar_today, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JadwalLabScreen()))),
                      _buildMenuCard(context, 'Peraturan', 'Ketentuan peminjaman', Icons.description, () => _showPeraturanDialog(context)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('© 2026 Laboratorium Informatika UMSIDA', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]), boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 10, spreadRadius: 1)]),
                child: Icon(icon, size: 35, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}