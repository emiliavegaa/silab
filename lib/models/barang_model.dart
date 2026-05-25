class Barang {
  final String id;
  final String namaBarang;
  final String spesifikasi;
  final int stok;
  final int stokTersedia;
  final String kondisi;
  final String statusBarang;
  final String? fotoUrl;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.spesifikasi,
    required this.stok,
    required this.stokTersedia,
    required this.kondisi,
    required this.statusBarang,
    this.fotoUrl,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id_barang'] ?? json['id'] ?? '',
      namaBarang: json['nama_barang'] ?? '',
      spesifikasi: json['spesifikasi'] ?? '',
      stok: json['stok'] ?? 0,
      stokTersedia: json['stok_tersedia'] ?? json['stok'] ?? 0,
      kondisi: json['kondisi'] ?? 'baik',
      statusBarang: json['status_barang'] ?? 'tersedia',
      fotoUrl: json['foto_url'],
    );
  }
}