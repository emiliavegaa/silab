import 'package:flutter/material.dart';

class PeminjamanItem {
  final String id;
  final String namaBarang;
  final int jumlah;
  final String tanggal;
  final String status;
  final String alasan;
  final int durasiJam;

  PeminjamanItem({
    required this.id,
    required this.namaBarang,
    required this.jumlah,
    required this.tanggal,
    required this.status,
    required this.alasan,
    required this.durasiJam,
  });
}

class PeminjamanProvider extends ChangeNotifier {
  List<PeminjamanItem> _riwayat = [];

  List<PeminjamanItem> get riwayat => _riwayat;

  void addPeminjaman(PeminjamanItem item) {
    _riwayat.insert(0, item);
    notifyListeners();
  }

  void updateStatus(String id, String statusBaru) {
    final index = _riwayat.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = _riwayat[index];
      _riwayat[index] = PeminjamanItem(
        id: item.id,
        namaBarang: item.namaBarang,
        jumlah: item.jumlah,
        tanggal: item.tanggal,
        status: statusBaru,
        alasan: item.alasan,
        durasiJam: item.durasiJam,
      );
      notifyListeners();
    }
  }
}