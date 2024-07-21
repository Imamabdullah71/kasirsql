// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_transaksi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailTransaksi _$DetailTransaksiFromJson(Map<String, dynamic> json) =>
    DetailTransaksi(
      id: (json['id'] as num?)?.toInt(),
      transaksiId: (json['transaksiId'] as num).toInt(),
      nama: json['nama'] as String,
      jumlah: (json['jumlah'] as num).toInt(),
      harga: (json['harga'] as num).toDouble(),
      jumlahHarga: (json['jumlahHarga'] as num).toDouble(),
    );

Map<String, dynamic> _$DetailTransaksiToJson(DetailTransaksi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaksiId': instance.transaksiId,
      'nama': instance.nama,
      'jumlah': instance.jumlah,
      'harga': instance.harga,
      'jumlahHarga': instance.jumlahHarga,
    };
