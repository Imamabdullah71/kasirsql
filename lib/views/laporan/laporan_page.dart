import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:kasirsql/controllers/laporan_controller/laporan_controller.dart';

class LaporanPage extends StatelessWidget {
  final LaporanController laporanController = Get.find<LaporanController>();

  LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Laporan Transaksi",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownSearch<String>(
              items: const [
                'Laporan hari ini',
                'Laporan minggu ini',
                'Laporan bulan ini',
                'Laporan Keseluruhan'
              ],
              onChanged: (value) {
                laporanController.fetchLaporan(value!);
              },
              selectedItem: 'Laporan hari ini',
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Obx(() => Text(
                        'Total Pemasukan: ${laporanController.formatRupiah(laporanController.totalPemasukan.value)}')),
                    const Divider(),
                    Obx(() => Text(
                        'Total Pengeluaran: ${laporanController.formatRupiah(laporanController.totalPengeluaran.value)}')),
                    const Divider(),
                    Obx(() => Text(
                        'Laba Bersih: ${laporanController.formatRupiah(laporanController.labaBersih.value)}')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
