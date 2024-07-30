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
        title: Text('Laporan Transaksi'),
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
            Obx(() => Text(
                'Total Pemasukan: ${laporanController.formatRupiah(laporanController.totalPemasukan.value)}')),
            Obx(() => Text(
                'Total Pengeluaran: ${laporanController.formatRupiah(laporanController.totalPengeluaran.value)}')),
            Obx(() => Text(
                'Laba Bersih: ${laporanController.formatRupiah(laporanController.labaBersih.value)}')),
          ],
        ),
      ),
    );
  }
}
