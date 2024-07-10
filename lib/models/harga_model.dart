class Harga {
  int id;
  double hargaJual;
  double hargaBeli;
  int barangId;

  Harga({
    required this.id,
    required this.hargaJual,
    required this.hargaBeli,
    required this.barangId,
  });

  factory Harga.fromJson(Map<String, dynamic> json) {
    return Harga(
      id: int.parse(json['id'].toString()),
      hargaJual: double.parse(json['harga_jual'].toString()),
      hargaBeli: double.parse(json['harga_beli'].toString()),
      barangId: int.parse(json['barang_id'].toString()),
    );
  }
}
