class User {
  final String id;
  final String nama;
  final String nim;
  final String prodi;
  final String? email;

  User({
    required this.id,
    required this.nama,
    required this.nim,
    required this.prodi,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'] ?? json['id'] ?? '',
      nama: json['nama_user'] ?? json['nama'] ?? '',
      nim: json['nim'] ?? '',
      prodi: json['prodi'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'nama_user': nama,
      'nim': nim,
      'prodi': prodi,
      'email': email,
    };
  }
}