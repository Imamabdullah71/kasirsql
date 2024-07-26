class Transaksi {
  final int? id;
  final int totalBarang;
  final double totalHarga;
  final double totalHargaBeli;
  final double bayar;
  final double kembali;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaksi({
    this.id,
    required this.totalBarang,
    required this.totalHarga,
    required this.totalHargaBeli,
    required this.bayar,
    required this.kembali,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_barang': totalBarang,
      'total_harga': totalHarga,
      'total_harga_beli': totalHargaBeli,
      'bayar': bayar,
      'kembali': kembali,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      totalBarang: json['total_barang'],
      totalHarga: json['total_harga'],
      totalHargaBeli: json['total_harga_beli'],
      bayar: json['bayar'],
      kembali: json['kembali'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
