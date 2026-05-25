import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'jadwal_lab_screen.dart';
import 'pilih_komputer_screen.dart';
import '../services/auth_service.dart';
import '../providers/jadwal_provider.dart';
import '../providers/peminjaman_lab_provider.dart';
import '../models/jadwal_model.dart';
import 'riwayat_peminjaman_lab_screen.dart';

class PeminjamanLabScreen extends StatefulWidget {
  const PeminjamanLabScreen({super.key});

  @override
  State<PeminjamanLabScreen> createState() => _PeminjamanLabScreenState();
}

class _PeminjamanLabScreenState extends State<PeminjamanLabScreen> {
  String? selectedLab;
  String? selectedType;
  DateTime? selectedDate;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  final List<Map<String, dynamic>> labs = [
    {'id': '1', 'nama': 'Laboratorium Sistem Komputer', 'kapasitas': 40, 'lokasi': 'Lantai 2'},
    {'id': '2', 'nama': 'Laboratorium Game dan Multimedia', 'kapasitas': 40, 'lokasi': 'Lantai 2'},
    {'id': '3', 'nama': 'Laboratorium Sistem Cerdas', 'kapasitas': 40, 'lokasi': 'Lantai 3'},
    {'id': '4', 'nama': 'Laboratorium Komputasi', 'kapasitas': 40, 'lokasi': 'Lantai 3'},
    {'id': '5', 'nama': 'Laboratorium Algoritma Pemrograman', 'kapasitas': 40, 'lokasi': 'Lantai 4'},
    {'id': '6', 'nama': 'Laboratorium Rekayasa Perangkat Lunak', 'kapasitas': 40, 'lokasi': 'Lantai 4'},
  ];

  bool _isLabBooked(String labId, DateTime start, DateTime end) {
    final jadwalProvider = Provider.of<JadwalProvider>(context, listen: false);
    final labName = labs.firstWhere((l) => l['id'] == labId)['nama'];
    for (var item in jadwalProvider.jadwal) {
      if (item.lab == labName && item.jam != '-') {
        final jamParts = item.jam.split(' - ');
        if (jamParts.length == 2) {
          try {
            final startJam = DateFormat('HH:mm').parse(jamParts[0]);
            final endJam = DateFormat('HH:mm').parse(jamParts[1]);
            final startExist = DateTime(start.year, start.month, start.day, startJam.hour, startJam.minute);
            final endExist = DateTime(start.year, start.month, start.day, endJam.hour, endJam.minute);
            if (start.isBefore(endExist) && end.isAfter(startExist)) return true;
          } catch (e) {}
        }
      }
    }
    return false;
  }

  void _proceed() {
    if (selectedType == null || selectedLab == null || selectedDate == null || selectedStartTime == null || selectedEndTime == null) return;

    final start = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
        selectedStartTime!.hour, selectedStartTime!.minute);
    final end = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
        selectedEndTime!.hour, selectedEndTime!.minute);
    final labName = labs.firstWhere((l) => l['id'] == selectedLab)['nama'];

    if (_isLabBooked(selectedLab!, start, end)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Lab Sudah Dipinjam', style: TextStyle(color: Colors.orange)),
          content: Text('Laboratorium $labName pada waktu tersebut sudah dipinjam. Silakan pilih waktu atau lab lain.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK', style: TextStyle(color: Colors.cyan)))],
        ),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    final labProvider = Provider.of<PeminjamanLabProvider>(context, listen: false);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final tanggalFormatted = DateFormat('dd/MM/yyyy').format(start);
    final waktuFormatted = '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}';
    labProvider.addPeminjaman(PeminjamanLabItem(
      id: id,
      nim: user?.nim ?? '-',
      nama: user?.nama ?? '-',
      lab: labName,
      tanggal: tanggalFormatted,
      waktu: waktuFormatted,
      status: 'pending',
    ));

    _showSuccessDialog(labName, tanggalFormatted, waktuFormatted, selectedType!);
  }

  // ========== DIALOG SUKSES YANG DIPERBAIKI TOTAL ==========
  void _showSuccessDialog(String labName, String tanggal, String waktu, String tipe) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        elevation: 0,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pengajuan Berhasil!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                'Peminjaman Lab Anda sedang menunggu persetujuan admin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              // Ringkasan menggunakan ListTile yang rapi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.computer, 'Laboratorium', labName),
                    const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
                    _buildInfoTile(Icons.event_note, 'Tipe', tipe == 'workshop' ? 'Workshop / Seminar' : 'Non Workshop'),
                    const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
                    _buildInfoTile(Icons.calendar_today, 'Tanggal', tanggal),
                    const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16),
                    _buildInfoTile(Icons.access_time, 'Waktu', waktu),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Lihat Detail', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade700),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
  // ========== AKHIR DIALOG SUKSES ==========

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Peminjaman Laboratorium', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
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
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [IconButton(icon: const Icon(Icons.history, color: Colors.white), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiwayatPeminjamanLabScreen())))],
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildTipePeminjaman(),
                const SizedBox(height: 24),
                _buildPilihLaboratorium(),
                const SizedBox(height: 24),
                _buildWaktuPeminjaman(),
                const SizedBox(height: 32),
                _buildLanjutkanButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white.withOpacity(0.2), Colors.blue.shade200.withOpacity(0.15)]),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue.shade300.withOpacity(0.5), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.blue.shade300.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]), borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 8)]), child: const Icon(Icons.info, color: Colors.white, size: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Informasi Peminjaman Lab', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)), Text('Silakan cek jadwal lab terlebih dahulu sebelum meminjam', style: TextStyle(fontSize: 12, color: Colors.white70))])),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JadwalLabScreen())), style: TextButton.styleFrom(backgroundColor: Colors.blue.shade800.withOpacity(0.7), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: BorderSide(color: Colors.blue.shade300, width: 1)), child: const Text('Cek Jadwal', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTipePeminjaman() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipe Peminjaman', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTypeCard('Non Workshop', 'Mahasiswa biasa', Icons.person, selectedType == 'non_workshop', () => setState(() => selectedType = 'non_workshop'), Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: _buildTypeCard('Workshop/Seminar', 'Event/Lomba', Icons.event, selectedType == 'workshop', () => setState(() => selectedType = 'workshop'), Colors.orange)),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard(String title, String subtitle, IconData icon, bool isSelected, VoidCallback onTap, Color accentColor) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: [accentColor, accentColor.withOpacity(0.7)]) : LinearGradient(colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: isSelected ? accentColor : Colors.white.withOpacity(0.3), width: 1.5),
          boxShadow: isSelected ? [BoxShadow(color: accentColor.withOpacity(0.6), blurRadius: 12, spreadRadius: 2)] : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.cyan.shade200, size: 24),
            const SizedBox(width: 8),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white)), Text(subtitle, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.white60))])),
          ],
        ),
      ),
    );
  }

  Widget _buildPilihLaboratorium() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pilih Laboratorium (geser ke kanan)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: labs.length,
            itemBuilder: (context, index) {
              final lab = labs[index];
              final isSelected = selectedLab == lab['id'];
              return GestureDetector(
                onTap: () { setState(() => selectedLab = lab['id']); _showLabDetail(lab); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 190,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? const LinearGradient(colors: [Colors.blueAccent, Colors.cyan]) : LinearGradient(colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: isSelected ? Colors.cyan : Colors.white.withOpacity(0.3), width: 1.5),
                    boxShadow: isSelected ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.computer, size: 45, color: isSelected ? Colors.white : Colors.cyan.shade200),
                      const SizedBox(height: 8),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(lab['nama'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.white), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
                      Text('${lab['kapasitas']} PC', style: TextStyle(fontSize: 11, color: isSelected ? Colors.white70 : Colors.white60)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWaktuPeminjaman() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Waktu Peminjaman', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withOpacity(0.15), Colors.blue.shade900.withOpacity(0.3)]), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.blue.shade300.withOpacity(0.5), width: 1.5), boxShadow: [BoxShadow(color: Colors.blue.shade300.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))]),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildWaktuTile(icon: Icons.calendar_today, title: 'Tanggal Peminjaman', value: selectedDate == null ? 'Belum dipilih' : DateFormat('EEEE, d MMMM yyyy', 'id').format(selectedDate!), onTap: () async { final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 30)), locale: const Locale('id', 'ID')); if (date != null) setState(() => selectedDate = date); }),
                const Divider(color: Colors.white30),
                _buildWaktuTile(icon: Icons.access_time, title: 'Jam Mulai', value: selectedStartTime == null ? 'Belum dipilih' : selectedStartTime!.format(context), onTap: () async { final time = await showTimePicker(context: context, initialTime: TimeOfDay.now()); if (time != null) setState(() => selectedStartTime = time); }),
                const Divider(color: Colors.white30),
                _buildWaktuTile(icon: Icons.access_time, title: 'Jam Selesai', value: selectedEndTime == null ? 'Belum dipilih' : selectedEndTime!.format(context), onTap: () async { final time = await showTimePicker(context: context, initialTime: TimeOfDay.now()); if (time != null) setState(() => selectedEndTime = time); }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaktuTile({required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return ListTile(
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.blue, Colors.cyan]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 6)]), child: Icon(icon, color: Colors.white, size: 20)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white70)),
      trailing: IconButton(icon: const Icon(Icons.edit, color: Colors.cyan), onPressed: onTap),
    );
  }

  Widget _buildLanjutkanButton() {
    final bool canProceed = _canProceed();
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(gradient: canProceed ? const LinearGradient(colors: [Colors.blue, Colors.cyan]) : null, borderRadius: BorderRadius.circular(30), boxShadow: canProceed ? [BoxShadow(color: Colors.blue.shade300.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))] : null),
      child: Material(
        color: canProceed ? Colors.transparent : Colors.grey.shade700.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: canProceed ? _proceed : null,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: canProceed ? Colors.white.withOpacity(0.5) : Colors.grey.shade600, width: 1.5)),
            child: Text(selectedType == 'workshop' ? 'Lanjutkan ke Form Workshop' : 'Lanjutkan ke Pemilihan Nomor Komputer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: canProceed ? Colors.white : Colors.white.withOpacity(0.7)), textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  bool _canProceed() => selectedLab != null && selectedType != null && selectedDate != null && selectedStartTime != null && selectedEndTime != null;

  void _showLabDetail(Map<String, dynamic> lab) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.blue.shade900,
        title: Text(lab['nama'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📍 Lokasi: ${lab['lokasi']}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('💻 Kapasitas: ${lab['kapasitas']} PC', style: const TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup', style: TextStyle(color: Colors.cyan)))],
      ),
    );
  }
}