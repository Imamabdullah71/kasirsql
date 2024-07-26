class DetailTransaksi {
  final int? id;
  final int transaksiId;
  final String namaBarang;
  final int jumlahBarang;
  final double hargaBarang;
  final double jumlahHarga;
  final DateTime createdAt;
  final DateTime updatedAt;

  DetailTransaksi({
    this.id,
    required this.transaksiId,
    required this.namaBarang,
    required this.jumlahBarang,
    required this.hargaBarang,
    required this.jumlahHarga,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaksi_id': transaksiId,
      'nama_barang': namaBarang,
      'jumlah_barang': jumlahBarang,
      'harga_barang': hargaBarang,
      'jumlah_harga': jumlahHarga,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) {
    return DetailTransaksi(
      id: json['id'],
      transaksiId: json['transaksi_id'],
      namaBarang: json['nama_barang'],
      jumlahBarang: json['jumlah_barang'],
      hargaBarang: json['harga_barang'],
      jumlahHarga: json['jumlah_harga'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
