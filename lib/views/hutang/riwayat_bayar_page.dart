import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:intl/intl.dart';

class RiwayatBayarPage extends StatelessWidget {
  final int hutangId;
  final HutangController hutangController = Get.put(HutangController());

  RiwayatBayarPage({super.key, required this.hutangId});

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: hutangController.fetchRiwayatPembayaran(hutangId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Obx(() {
              // Sort the list based on tanggalBayar in descending order
              var sortedRiwayatList = hutangController.riwayatList.toList();
              sortedRiwayatList
                  .sort((a, b) => b.tanggalBayar.compareTo(a.tanggalBayar));

              return ListView.builder(
                itemCount: sortedRiwayatList.length,
                itemBuilder: (context, index) {
                  var riwayat = sortedRiwayatList[index];
                  return ListTile(
                    title: Text(formatTanggal(riwayat.tanggalBayar)),
                    subtitle: Text(
                        'Hutang ${formatRupiah(riwayat.sisaHutangSebelum)}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('+ ${formatRupiah(riwayat.jumlahBayar)}'),
                        Text(
                            'Sisa Hutang ${formatRupiah(riwayat.sisaHutangSekarang)}'),
                      ],
                    ),
                  );
                },
              );
            });
          }
        },
      ),
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
