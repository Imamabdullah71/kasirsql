class RiwayatPembayaran {
  final int? id;
  final int hutangId;
  final double sisaHutangSebelum;
  final double sisaHutangSekarang;
  final double jumlahBayar;
  final DateTime tanggalBayar;

  RiwayatPembayaran({
    this.id,
    required this.hutangId,
    required this.sisaHutangSebelum,
    required this.sisaHutangSekarang,
    required this.jumlahBayar,
    required this.tanggalBayar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hutang_id': hutangId,
      'sisa_hutang_sebelum': sisaHutangSebelum,
      'sisa_hutang_sekarang': sisaHutangSekarang,
      'jumlah_bayar': jumlahBayar,
      'tanggal_bayar': tanggalBayar.toIso8601String(),
    };
  }

  factory RiwayatPembayaran.fromJson(Map<String, dynamic> json) {
    return RiwayatPembayaran(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      hutangId: int.parse(json['hutang_id'].toString()),
      sisaHutangSebelum: double.parse(json['sisa_hutang_sebelum'].toString()),
      sisaHutangSekarang: double.parse(json['sisa_hutang_sekarang'].toString()),
      jumlahBayar: double.parse(json['jumlah_bayar'].toString()),
      tanggalBayar: DateTime.parse(json['tanggal_bayar']),
    );
  }
}
