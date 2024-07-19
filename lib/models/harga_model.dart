// models/harga_model.dart
class Harga {
  final int id;
  final int barangId;
  final double hargaBeli;
  final double hargaJual;
  final DateTime createdAt;
  final DateTime updatedAt;

  Harga({
    required this.id,
    required this.barangId,
    required this.hargaBeli,
    required this.hargaJual,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Harga.fromJson(Map<String, dynamic> json) {
    return Harga(
      id: json['id'],
      barangId: json['barang_id'],
      hargaBeli: json['harga_beli'],
      hargaJual: json['harga_jual'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barang_id': barangId,
      'harga_beli': hargaBeli,
      'harga_jual': hargaJual,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}