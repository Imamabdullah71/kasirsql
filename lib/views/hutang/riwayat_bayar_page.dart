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
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Riwayat Pembayaran",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Add this line to set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatTanggal(riwayat.tanggalBayar),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hutang Sebelum: ${formatRupiah(riwayat.sisaHutangSebelum)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              '+ ${formatRupiah(riwayat.jumlahBayar)}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.green),
                            ),
                            Text(
                              'Sisa Hutang: ${formatRupiah(riwayat.sisaHutangSekarang)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
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
    final DateFormat formatter = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
    return formatter.format(date);
  }

  String formatRupiah(double amount) {
    double absoluteAmount = amount.abs();
    return 'Rp ${absoluteAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
