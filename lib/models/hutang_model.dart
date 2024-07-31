class Hutang {
  final int? id;
  final int transaksiId;
  final String nama;
  final double sisaHutang;
  final String status;
  final DateTime tanggalMulai;

  Hutang({
    this.id,
    required this.transaksiId,
    required this.nama,
    required this.sisaHutang,
    this.status = 'belum lunas',
    required this.tanggalMulai,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaksi_id': transaksiId,
      'nama': nama,
      'sisa_hutang': sisaHutang,
      'status': status,
      'tanggal_mulai': tanggalMulai.toIso8601String(),
    };
  }

  factory Hutang.fromJson(Map<String, dynamic> json) {
    return Hutang(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      transaksiId: int.parse(json['transaksi_id'].toString()),
      nama: json['nama'],
      sisaHutang: double.parse(json['sisa_hutang'].toString()),
      status: json['status'] ?? 'belum lunas',
      tanggalMulai: DateTime.parse(json['tanggal_mulai']),
    );
  }
}
