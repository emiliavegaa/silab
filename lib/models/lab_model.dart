class Lab {
  final String id;
  final String namaLab;
  final String lokasi;
  final List<int> komputerTersedia;
  final Map<int, bool> statusKomputer;
  final String statusLab;

  Lab({
    required this.id,
    required this.namaLab,
    required this.lokasi,
    required this.komputerTersedia,
    required this.statusKomputer,
    required this.statusLab,
  });

  factory Lab.fromJson(Map<String, dynamic> json) {
    return Lab(
      id: json['id_lab'] ?? json['id'] ?? '',
      namaLab: json['nama_lab'] ?? '',
      lokasi: json['lokasi'] ?? '',
      komputerTersedia: List<int>.from(json['komputer_tersedia'] ?? []),
      statusKomputer: { for (var item in json['status_komputer'] ?? {}) int.parse(item.toString().split(':')[0]) : item.toString().split(':')[1] == 'true' },
      statusLab: json['status_lab'] ?? 'tersedia',
    );
  }
}

class JadwalLab {
  final String labId;
  final String namaLab;
  final DateTime tanggal;
  final String jamMulai;
  final String jamSelesai;
  final String kegiatan;
  final String dosenPengampu;

  JadwalLab({
    required this.labId,
    required this.namaLab,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kegiatan,
    required this.dosenPengampu,
  });
}