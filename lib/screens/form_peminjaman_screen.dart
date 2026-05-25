import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/jadwal_provider.dart';
import '../models/jadwal_model.dart';

// ==================== FORM WORKSHOP (DENGAN FIELD JELAS) ====================
class FormWorkshopScreen extends StatefulWidget {
  final String labId;
  final String labName;
  final DateTime startTime;
  final DateTime endTime;
  const FormWorkshopScreen({
    super.key,
    required this.labId,
    required this.labName,
    required this.startTime,
    required this.endTime,
  });

  @override
  State<FormWorkshopScreen> createState() => _FormWorkshopScreenState();
}

class _FormWorkshopScreenState extends State<FormWorkshopScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaWorkshopController = TextEditingController();
  final _catatanController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaWorkshopController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _submitWorkshop() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1)); // simulasi proses
      setState(() => _isLoading = false);

      // Simpan data ke provider
      final auth = Provider.of<AuthService>(context, listen: false);
      final user = auth.currentUser;
      final jadwalProvider =
          Provider.of<JadwalProvider>(context, listen: false);
      final jamRange =
          '${DateFormat('HH:mm').format(widget.startTime)} - ${DateFormat('HH:mm').format(widget.endTime)}';
      jadwalProvider.addBooking(JadwalItem(
        lab: widget.labName,
        jam: jamRange,
        kegiatan: 'WORKSHOP: ${_namaWorkshopController.text}',
        dosen: user?.nama ?? 'Mahasiswa',
        status: 'Dipesan (Workshop)',
        catatan:
            _catatanController.text.isNotEmpty ? _catatanController.text : null,
      ));

      // Tampilkan pop-up sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: Colors.white,
          title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Booking Workshop Berhasil!',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 8),
              Text('Laboratorium: ${widget.labName}',
                  style: const TextStyle(color: Colors.black54)),
              Text(
                  'Waktu: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.startTime)} - ${DateFormat('HH:mm').format(widget.endTime)}',
                  style: const TextStyle(color: Colors.black54)),
              Text('Workshop: ${_namaWorkshopController.text}',
                  style: const TextStyle(color: Colors.black54)),
              if (_catatanController.text.isNotEmpty)
                Text('Catatan: ${_catatanController.text}',
                    style: const TextStyle(color: Colors.black54)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Kembali ke Beranda',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Form Workshop',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.blue.shade400
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ringkasan Peminjaman (opsional tapi membantu)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ringkasan Peminjaman',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        const SizedBox(height: 8),
                        _buildSummaryRow('Laboratorium', widget.labName),
                        _buildSummaryRow('Waktu',
                            '${DateFormat('dd/MM/yyyy HH:mm').format(widget.startTime)} - ${DateFormat('HH:mm').format(widget.endTime)}'),
                      ],
                    ),
                  ),
                  // Field Nama Workshop (wajib)
                  const Text(
                    'Nama Workshop',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _namaWorkshopController,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama workshop / seminar',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon:
                          const Icon(Icons.event_rounded, color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Nama workshop harus diisi'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  // Field Catatan (opsional)
                  const Text(
                    'Catatan (opsional)',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _catatanController,
                    style: const TextStyle(color: Colors.black87),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText:
                          'Misal: kebutuhan khusus, kekurangan kursi, dll.',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon:
                          const Icon(Icons.note_rounded, color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tombol Booking Workshop
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.blue))
                      : Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.blue, Colors.cyan],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _submitWorkshop,
                            child: const Text(
                              'Booking Workshop',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
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

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black54))),
          Expanded(
              child: Text(': $value',
                  style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
