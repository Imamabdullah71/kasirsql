import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/laporan_controller/laporan_controller.dart';
import 'package:kasirsql/views/laporan/bulan_page.dart';

class LaporanPage extends StatelessWidget {
  final LaporanController laporanController = Get.put(LaporanController());

  LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    laporanController.fetchYears();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan"),
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildYearDropdown(),
            const SizedBox(height: 20),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Pemasukan: ${laporanController.totalPemasukan.value}"),
                  Text("Total Pengeluaran: ${laporanController.totalPengeluaran.value}"),
                  Text("Laba Bersih: ${laporanController.labaBersih.value}"),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(() {
      if (laporanController.years.isEmpty) {
        return const CircularProgressIndicator();
      }

      return DropdownButton<int>(
        hint: const Text("Pilih Tahun"),
        items: laporanController.years.map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text(year.toString()),
          );
        }).toList(),
        onChanged: (year) {
          // Handle year change
          Get.to(() => BulanPage(year: year!));
        },
      );
    });
  }
}
