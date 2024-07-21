import 'package:json_annotation/json_annotation.dart';

part 'detail_transaksi_model.g.dart';

@JsonSerializable()
class DetailTransaksi {
  int? id;
  int transaksiId;
  String nama;
  int jumlah;
  double harga;
  double jumlahHarga;

  DetailTransaksi({
    this.id,
    required this.transaksiId,
    required this.nama,
    required this.jumlah,
    required this.harga,
    required this.jumlahHarga,
  });

  factory DetailTransaksi.fromJson(Map<String, dynamic> json) => _$DetailTransaksiFromJson(json);

  Map<String, dynamic> toJson() => _$DetailTransaksiToJson(this);
}
