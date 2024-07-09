// models\kategori_model.dart
class Kategori {
  int id;
  String namaKategori;

  Kategori({required this.id, required this.namaKategori});

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: int.parse(json['id'].toString()),
      namaKategori: json['nama_kategori'],
    );
  }
}
