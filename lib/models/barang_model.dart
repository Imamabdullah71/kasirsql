class Barang {
  int id;
  String namaBarang;
  int barcodeBarang;
  int stokBarang;
  int kategoriId;
  String namaKategori;
  double hargaJual;
  double hargaBeli;
  DateTime createdAt;
  DateTime updatedAt;
  String? gambar;

  Barang({
    required this.id,
    required this.namaBarang,
    required this.barcodeBarang,
    required this.stokBarang,
    required this.kategoriId,
    required this.namaKategori,
    required this.hargaJual,
    required this.hargaBeli,
    required this.createdAt,
    required this.updatedAt,
    this.gambar,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: int.parse(json['id'].toString()),
      namaBarang: json['nama_barang'],
      barcodeBarang: int.parse(json['barcode_barang'].toString()),
      stokBarang: int.parse(json['stok_barang'].toString()),
      kategoriId: int.parse(json['kategori_id'].toString()),
      namaKategori: json['nama_kategori'],
      hargaJual: double.tryParse(json['harga_jual'].toString()) ?? 0.0,
      hargaBeli: double.tryParse(json['harga_beli'].toString()) ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      gambar: json['gambar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_barang': namaBarang,
      'barcode_barang': barcodeBarang,
      'stok_barang': stokBarang,
      'kategori_id': kategoriId,
      'nama_kategori': namaKategori,
      'harga_jual': hargaJual,
      'harga_beli': hargaBeli,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'gambar': gambar,
    };
  }
}
