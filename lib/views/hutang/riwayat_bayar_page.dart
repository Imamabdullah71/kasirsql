import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/models/riwayat_pembayaran_model.dart';

class RiwayatBayarPage extends StatelessWidget {
  final HutangController hutangController = Get.find();
  final int hutangId;

  RiwayatBayarPage({super.key, required this.hutangId});

  @override
  Widget build(BuildContext context) {
    hutangController.fetchRiwayatPembayaran(
        hutangId); // Panggil fetchRiwayatPembayaran untuk memastikan data diambil saat halaman dibuka
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Riwayat Pembayaran",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (hutangController.riwayatList.isEmpty) {
          print('Riwayat list is empty'); // Logging jika list kosong
          return const Center(child: Text('Tidak ada data riwayat'));
        }
        if (hutangController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: hutangController.riwayatList.length,
          itemBuilder: (context, index) {
            RiwayatPembayaran riwayat = hutangController.riwayatList[index];
            return ListTile(
              title: Text(formatTanggal(riwayat.tanggalBayar)),
              subtitle: Text(
                  'Sisa Hutang Sebelum: ${formatRupiah(riwayat.sisaHutangSebelum)}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Jumlah Bayar: ${formatRupiah(riwayat.jumlahBayar)}'),
                  Text(
                      'Sisa Hutang Sekarang: ${formatRupiah(riwayat.sisaHutangSekarang)}'),
                ],
              ),
            );
          },
        );
      }),
      backgroundColor: Colors.white,
    );
  }

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(date);
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
