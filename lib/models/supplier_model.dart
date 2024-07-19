// models/supplier_model.dart
class Supplier {
  final int id;
  final String? gambar;
  final String namaSupplier;
  final String? namaTokoSupplier;
  final String? noTelepon;
  final String? email;
  final String? alamat;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Supplier({
    required this.id,
    this.gambar,
    required this.namaSupplier,
    this.namaTokoSupplier,
    this.noTelepon,
    this.email,
    this.alamat,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      gambar: json['gambar'],
      namaSupplier: json['nama_supplier'],
      namaTokoSupplier: json['nama_toko_supplier'],
      noTelepon: json['no_telepon'],
      email: json['email'],
      alamat: json['alamat'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gambar': gambar,
      'nama_supplier': namaSupplier,
      'nama_toko_supplier': namaTokoSupplier,
      'no_telepon': noTelepon,
      'email': email,
      'alamat': alamat,
      'user_id': userId, // Tambahkan userId
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
