// lib/providers/jadwal_provider.dart
import 'package:flutter/material.dart';
import '../models/jadwal_model.dart';

class JadwalProvider extends ChangeNotifier {
  List<JadwalItem> _jadwal = [
    JadwalItem(
      lab: 'Laboratorium Sistem Komputer',
      jam: '07:00 - 09:00',
      kegiatan: 'Praktikum Arsitektur Komputer',
      dosen: 'Dr. Ahmad, M.Kom',
      status: 'Dipakai',
    ),
    JadwalItem(
      lab: 'Laboratorium Game dan Multimedia',
      jam: '09:00 - 12:00',
      kegiatan: 'Praktikum Multimedia',
      dosen: 'Rina Dewi, M.MT',
      status: 'Dipakai',
    ),
    JadwalItem(
      lab: 'Laboratorium Sistem Cerdas',
      jam: '13:00 - 15:00',
      kegiatan: 'Kecerdasan Buatan',
      dosen: 'Budi Santoso, Ph.D',
      status: 'Dipakai',
    ),
    JadwalItem(
      lab: 'Laboratorium Komputasi',
      jam: '-',
      kegiatan: 'Tersedia',
      dosen: '-',
      status: 'Tersedia',
    ),
    JadwalItem(
      lab: 'Laboratorium Algoritma Pemrograman',
      jam: '10:00 - 12:00',
      kegiatan: 'Praktikum Algoritma',
      dosen: 'Siti Aminah, M.Kom',
      status: 'Dipakai',
    ),
    JadwalItem(
      lab: 'Laboratorium Rekayasa Perangkat Lunak',
      jam: '-',
      kegiatan: 'Tersedia',
      dosen: '-',
      status: 'Tersedia',
    ),
  ];

  List<JadwalItem> get jadwal => _jadwal;

  void addBooking(JadwalItem item) {
    _jadwal.add(item);
    notifyListeners();
  }
}