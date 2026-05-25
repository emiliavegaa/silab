import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/auth_service.dart';
import '../providers/peminjaman_provider.dart';
import 'riwayat_peminjaman_barang_screen.dart';

class BarangModel {
  final String id;
  final String nama;
  final String spesifikasi;
  final int stokTersedia;
  final String assetImage;

  BarangModel({
    required this.id,
    required this.nama,
    required this.spesifikasi,
    required this.stokTersedia,
    required this.assetImage,
  });
}

class PeminjamanBarangScreen extends StatefulWidget {
  const PeminjamanBarangScreen({super.key});

  @override
  State<PeminjamanBarangScreen> createState() => _PeminjamanBarangScreenState();
}

class _PeminjamanBarangScreenState extends State<PeminjamanBarangScreen> {
  final _formKey = GlobalKey<FormState>();
  final _alasanController = TextEditingController();
  final _lamaPinjamController = TextEditingController();

  Uint8List? _fotoAwalBytes;
  File? _fotoAwalFile;
  bool _isLoading = false;

  final Map<String, bool> _selectedBarang = {};
  final Map<String, int> _jumlahPinjam = {};

  final List<BarangModel> daftarBarang = [
    BarangModel(
        id: '1',
        nama: 'Obeng Set',
        spesifikasi: 'Set obeng + dan - ukuran kecil-sedang',
        stokTersedia: 7,
        assetImage: 'assets/images/obeng.jpg'),
    BarangModel(
        id: '2',
        nama: 'Tang Kombinasi',
        spesifikasi: 'Tang 6 inci, grip karet',
        stokTersedia: 3,
        assetImage: 'assets/images/tang.jpg'),
    BarangModel(
        id: '3',
        nama: 'Solder Listrik',
        spesifikasi: '30W, dengan stand',
        stokTersedia: 5,
        assetImage: 'assets/images/solder.jpg'),
    BarangModel(
        id: '4',
        nama: 'Multimeter Digital',
        spesifikasi: 'Digital, auto range',
        stokTersedia: 2,
        assetImage: 'assets/images/multimeter.jpg'),
    BarangModel(
        id: '5',
        nama: 'Kabel Jumper',
        spesifikasi: 'Set kabel jumper female-female',
        stokTersedia: 15,
        assetImage: 'assets/images/kabel.jpg'),
    BarangModel(
        id: '6',
        nama: 'Bor Mini',
        spesifikasi: 'Bor tangan mini, 12V',
        stokTersedia: 1,
        assetImage: 'assets/images/bor.jpg'),
  ];

  @override
  void initState() {
    super.initState();
    for (var barang in daftarBarang) {
      _selectedBarang[barang.id] = false;
      _jumlahPinjam[barang.id] = 1;
    }
  }

  @override
  void dispose() {
    _alasanController.dispose();
    _lamaPinjamController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (pickedFile != null && mounted) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => _fotoAwalBytes = bytes);
      } else {
        setState(() => _fotoAwalFile = File(pickedFile.path));
      }
    }
  }

  Widget _buildFotoPreview() {
    if (kIsWeb && _fotoAwalBytes != null) {
      return Image.memory(_fotoAwalBytes!,
          height: 160, width: double.infinity, fit: BoxFit.cover);
    } else if (!kIsWeb && _fotoAwalFile != null) {
      return Image.file(_fotoAwalFile!,
          height: 160, width: double.infinity, fit: BoxFit.cover);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_rounded,
              size: 42, color: Colors.blue.shade300),
          const SizedBox(height: 10),
          Text(
            'Ambil Foto Barang',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'Pastikan kondisi awal barang terlihat jelas',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _submitPeminjaman() async {
    if (_formKey.currentState!.validate()) {
      final barangDipilih =
          daftarBarang.where((b) => _selectedBarang[b.id] == true).toList();
      if (barangDipilih.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Silakan pilih minimal satu barang yang ingin dipinjam'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
      if ((kIsWeb && _fotoAwalBytes == null) ||
          (!kIsWeb && _fotoAwalFile == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Dokumentasi foto awal barang wajib dilampirkan'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.orange.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      final peminjamanProvider =
          Provider.of<PeminjamanProvider>(context, listen: false);
      final tanggalSekarang = DateTime.now().toString();
      final durasi = int.tryParse(_lamaPinjamController.text) ?? 0;

      final baseTimestamp = DateTime.now().millisecondsSinceEpoch;

      for (int i = 0; i < barangDipilih.length; i++) {
        final barang = barangDipilih[i];
        final id = '${baseTimestamp}_${i}_${barang.id}';

        peminjamanProvider.addPeminjaman(
          PeminjamanItem(
            id: id,
            namaBarang: barang.nama,
            jumlah: _jumlahPinjam[barang.id]!,
            tanggal: tanggalSekarang,
            status: 'pending',
            alasan: _alasanController.text,
            durasiJam: durasi,
          ),
        );
      }

      setState(() => _isLoading = false);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.blue.shade900,
        title: Column(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 72),
            SizedBox(height: 16),
            Text(
              'Pengajuan Berhasil!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          'Permintaan peminjaman alat perkakas Anda telah dicatat. Mohon tunggu persetujuan dari admin laboratorium.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        actionsPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('Kembali ke Beranda',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const RiwayatPeminjamanBarangScreen()));
                },
                child: const Text('Lihat Riwayat Peminjaman',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final user = auth.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Peminjaman Perkakas',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade900.withOpacity(0.8),
                Colors.blue.shade600.withOpacity(0.6)
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded,
                color: Colors.white, size: 24),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RiwayatPeminjamanBarangScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identitas Peminjam Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.3), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildProfileRow(Icons.person_rounded,
                              'Nama Peminjam', user?.nama ?? '-'),
                          const Divider(
                              color: Colors.white30,
                              height: 20,
                              thickness: 0.8),
                          _buildProfileRow(Icons.badge_rounded,
                              'NIM / Nomor Induk', user?.nim ?? '-'),
                          const Divider(
                              color: Colors.white30,
                              height: 20,
                              thickness: 0.8),
                          _buildProfileRow(Icons.school_rounded,
                              'Program Studi', user?.prodi ?? '-'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  _buildSectionHeader('Pilih Barang & Tentukan Jumlah',
                      Icons.construction_rounded),

                  // Grid Daftar Barang
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.63,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: daftarBarang.length,
                    itemBuilder: (context, index) {
                      final barang = daftarBarang[index];
                      final isOutOfStock = barang.stokTersedia == 0;
                      final isSelected = !isOutOfStock &&
                          (_selectedBarang[barang.id] ?? false);
                      final jumlah = _jumlahPinjam[barang.id] ?? 1;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.white.withOpacity(0.08)
                              : (isSelected
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.white.withOpacity(0.15)),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isOutOfStock
                                ? Colors.white.withOpacity(0.2)
                                : (isSelected
                                    ? Colors.cyan
                                    : Colors.white.withOpacity(0.3)),
                            width: isSelected ? 2 : 1.5,
                          ),
                          boxShadow: isOutOfStock
                              ? []
                              : (isSelected
                                  ? [
                                      BoxShadow(
                                          color: Colors.cyan.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4))
                                    ]
                                  : [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2))
                                    ]),
                        ),
                        child: InkWell(
                          onTap: isOutOfStock
                              ? null
                              : () {
                                  setState(() {
                                    _selectedBarang[barang.id] = !isSelected;
                                  });
                                },
                          borderRadius: BorderRadius.circular(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Stack dengan Checkbox terpadu
                              Stack(
                                children: [
                                  Opacity(
                                    opacity: isOutOfStock ? 0.5 : 1.0,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(24)),
                                      child: Image.asset(
                                        barang.assetImage,
                                        height: 125,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 125,
                                          color: Colors.grey.shade800,
                                          child: Icon(
                                              Icons.image_not_supported_rounded,
                                              color: Colors.grey.shade400),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Custom Checkmark Indicator
                                  if (!isOutOfStock)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.cyan
                                              : Colors.white.withOpacity(0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 14,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // Detail Konten Informasi Barang
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        barang.nama,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.5,
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        barang.spesifikasi,
                                        style: TextStyle(
                                            fontSize: 10.5,
                                            color: Colors.white70,
                                            height: 1.3),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      // Status Stok Kapsul Modern
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isOutOfStock
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.green.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: isOutOfStock
                                                    ? Colors.red.shade400
                                                    : Colors.green.shade400,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              isOutOfStock
                                                  ? 'Habis'
                                                  : 'Stok: ${barang.stokTersedia}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: isOutOfStock
                                                    ? Colors.red.shade300
                                                    : Colors.green.shade300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Counter section yang dinamis / Pilih Alat Button
                                      if (isSelected)
                                        Container(
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.cyan
                                                    .withOpacity(0.5),
                                                width: 0.8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Minus
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                          left: Radius.circular(
                                                              10)),
                                                  onTap: jumlah > 1
                                                      ? () => setState(() =>
                                                          _jumlahPinjam[barang
                                                              .id] = jumlah - 1)
                                                      : () => setState(() =>
                                                          _selectedBarang[barang
                                                              .id] = false),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        Icons.remove_rounded,
                                                        size: 16,
                                                        color: Colors.cyan),
                                                  ),
                                                ),
                                              ),
                                              // Value
                                              Text(
                                                '$jumlah',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              // Plus
                                              Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                          right:
                                                              Radius.circular(
                                                                  10)),
                                                  onTap: jumlah <
                                                          barang.stokTersedia
                                                      ? () => setState(() =>
                                                          _jumlahPinjam[barang
                                                              .id] = jumlah + 1)
                                                      : null,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                        Icons.add_rounded,
                                                        size: 16,
                                                        color: jumlah <
                                                                barang
                                                                    .stokTersedia
                                                            ? Colors.cyan
                                                            : Colors
                                                                .grey.shade500),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        SizedBox(
                                          height: 34,
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: isOutOfStock
                                                    ? Colors.white
                                                        .withOpacity(0.3)
                                                    : Colors.cyan,
                                                width: 1.2,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor: isOutOfStock
                                                  ? Colors.white
                                                      .withOpacity(0.05)
                                                  : Colors.transparent,
                                              padding: EdgeInsets.zero,
                                            ),
                                            onPressed: isOutOfStock
                                                ? null
                                                : () => setState(() =>
                                                    _selectedBarang[barang.id] =
                                                        true),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  isOutOfStock
                                                      ? Icons.block_rounded
                                                      : Icons.add_rounded,
                                                  size: 14,
                                                  color: isOutOfStock
                                                      ? Colors.white38
                                                      : Colors.cyan,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  isOutOfStock
                                                      ? 'Stok Habis'
                                                      : 'Pilih Alat',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: isOutOfStock
                                                        ? Colors.white38
                                                        : Colors
                                                            .white, // Diubah menjadi putih
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      'Detail Peminjaman', Icons.assignment_rounded),

                  CustomTextField(
                    controller: _alasanController,
                    label: 'Alasan Peminjaman',
                    hint: 'Contoh: Praktikum Pemrograman Tertanam modul 4',
                    prefixIcon: Icons.edit_note_rounded,
                    maxLines: 2,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Alasan peminjaman tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  CustomTextField(
                    controller: _lamaPinjamController,
                    label: 'Durasi Peminjaman (Jam)',
                    hint: 'Masukkan estimasi durasi waktu',
                    prefixIcon: Icons.schedule_rounded,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Durasi waktu wajib diisi';
                      final durasi = int.tryParse(v);
                      if (durasi == null || durasi < 1) {
                        return 'Durasi minimal 1 jam';
                      }
                      if (durasi > 168)
                        return 'Durasi maksimal 168 jam (7 hari)';
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  _buildSectionHeader(
                      'Dokumentasi Kondisi Awal', Icons.camera_alt_rounded),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.5),
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: _buildFotoPreview(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Informasi Peraturan/Denda
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: Colors.orange.shade300, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Informasi Penting:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade300,
                                      fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                  '• Terlambat mengembalikan dikenakan denda Rp 2.000 / jam.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade200,
                                      height: 1.4)),
                              Text(
                                  '• Jagalah kondisi komponen perkakas agar tidak rusak/hilang.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade200,
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  // Submit Button
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                                CircularProgressIndicator(color: Colors.cyan),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.cyan],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade300.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5),
                            ),
                            onPressed: _submitPeminjaman,
                            child: const Text(
                              'Ajukan Peminjaman',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
