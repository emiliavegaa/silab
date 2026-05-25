import 'package:flutter/material.dart';

class PeminjamanLabItem {
  final String id;
  final String nim;
  final String nama;
  final String lab;
  final String tanggal;
  final String waktu;
  final String status;

  PeminjamanLabItem({
    required this.id,
    required this.nim,
    required this.nama,
    required this.lab,
    required this.tanggal,
    required this.waktu,
    required this.status,
  });
}

class PeminjamanLabProvider extends ChangeNotifier {
  List<PeminjamanLabItem> _riwayat = [];

  List<PeminjamanLabItem> get riwayat => _riwayat;

  void addPeminjaman(PeminjamanLabItem item) {
    _riwayat.insert(0, item);
    notifyListeners();
  }
}