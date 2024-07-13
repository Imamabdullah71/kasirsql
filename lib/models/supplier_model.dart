class Supplier {
  int id;
  String namaSupplier;
  String namaTokoSupplier;
  String? noTelepon;
  String? email;
  String? alamat;
  String? gambar;

  Supplier({
    required this.id,
    required this.namaSupplier,
    required this.namaTokoSupplier,
    this.noTelepon,
    this.email,
    this.alamat,
    this.gambar,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: int.parse(json['id'].toString()),
      namaSupplier: json['nama_supplier'],
      namaTokoSupplier: json['nama_toko_supplier'],
      noTelepon: json['no_telepon'],
      email: json['email'],
      alamat: json['alamat'],
      gambar: json['gambar'],
    );
  }
}
