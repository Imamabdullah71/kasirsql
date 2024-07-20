import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';

class TransaksiDetailPage extends StatelessWidget {
  final RiwayatController riwayatController = Get.find<RiwayatController>();
  final Map<String, dynamic> transaksi;

  TransaksiDetailPage({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    var detailBarang = json.decode(transaksi['detail_barang']) as List;

    // Menggunakan double.tryParse untuk menghindari TypeError
    double totalHarga = double.tryParse(transaksi['total_harga'].toString()) ?? 0.0;
    double bayar = double.tryParse(transaksi['bayar'].toString()) ?? 0.0;
    double kembali = double.tryParse(transaksi['kembali'].toString()) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi ${transaksi['id']}'),
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Transaksi: ${transaksi['id']}'),
            Text('Total Barang: ${transaksi['total_barang']}'),
            Text('Total Harga: ${riwayatController.formatRupiah(totalHarga)}'),
            Text('Bayar: ${riwayatController.formatRupiah(bayar)}'),
            Text('Kembali: ${riwayatController.formatRupiah(kembali)}'),
            Text('User ID: ${transaksi['user_id']}'),
            Text('Tanggal: ${transaksi['created_at']}'),
            const SizedBox(height: 20),
            const Text('Detail Barang:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: detailBarang.length,
                itemBuilder: (context, index) {
                  var barang = detailBarang[index];
                  return ListTile(
                    title: Text('${barang['nama']} x ${barang['jumlah']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
