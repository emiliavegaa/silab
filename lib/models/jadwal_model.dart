class JadwalItem {
  final String lab;
  final String jam;
  final String kegiatan;
  final String dosen;
  final String status;
  final String? catatan;

  JadwalItem({
    required this.lab,
    required this.jam,
    required this.kegiatan,
    required this.dosen,
    required this.status,
    this.catatan,
  });
}