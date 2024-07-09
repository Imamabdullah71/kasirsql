// models\barang_model.dart
class Barang {
  int id;
  String namaBarang;
  int kodeBarang;
  int stokBarang;
  int kategoriId;
  String namaKategori;
  DateTime createdAt;
  DateTime updatedAt;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.kodeBarang,
    required this.stokBarang,
    required this.kategoriId,
    required this.namaKategori,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: int.parse(json['id'].toString()),
      namaBarang: json['nama_barang'],
      kodeBarang: int.parse(json['kode_barang'].toString()),
      stokBarang: int.parse(json['stok_barang'].toString()),
      kategoriId: int.parse(json['kategori_id'].toString()),
      namaKategori: json['nama_kategori'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
