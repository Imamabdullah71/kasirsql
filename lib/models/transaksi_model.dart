import 'package:json_annotation/json_annotation.dart';

part 'transaksi_model.g.dart';

@JsonSerializable()
class Transaksi {
  int? id;
  List<Map<String, dynamic>> detailBarang;
  int totalBarang;
  double totalHarga;
  double bayar;
  double kembali;
  DateTime createdAt;
  DateTime updatedAt;

  Transaksi({
    this.id,
    required this.detailBarang,
    required this.totalBarang,
    required this.totalHarga,
    required this.bayar,
    required this.kembali,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => _$TransaksiFromJson(json);

  Map<String, dynamic> toJson() => _$TransaksiToJson(this);
}