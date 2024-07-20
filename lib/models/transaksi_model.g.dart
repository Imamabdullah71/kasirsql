// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaksi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaksi _$TransaksiFromJson(Map<String, dynamic> json) => Transaksi(
      id: (json['id'] as num?)?.toInt(),
      detailBarang: (json['detailBarang'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      totalBarang: (json['totalBarang'] as num).toInt(),
      totalHarga: (json['totalHarga'] as num).toDouble(),
      bayar: (json['bayar'] as num).toDouble(),
      kembali: (json['kembali'] as num).toDouble(),
      userId: (json['userId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TransaksiToJson(Transaksi instance) => <String, dynamic>{
      'id': instance.id,
      'detailBarang': instance.detailBarang,
      'totalBarang': instance.totalBarang,
      'totalHarga': instance.totalHarga,
      'bayar': instance.bayar,
      'kembali': instance.kembali,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
