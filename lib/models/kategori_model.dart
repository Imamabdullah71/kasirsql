// models/kategori_model.dart
class Kategori {
  final int id;
  final String namaKategori;
  final int userId; // Tambahkan userId
  final DateTime createdAt;
  final DateTime updatedAt;

  Kategori({
    required this.id,
    required this.namaKategori,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      namaKategori: json['nama_kategori'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'], 
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kategori': namaKategori,
      'user_id': userId, // Tambahkan userId
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
