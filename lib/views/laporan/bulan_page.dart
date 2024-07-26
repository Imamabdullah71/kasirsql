import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/laporan_controller/laporan_controller.dart';
import 'package:kasirsql/views/laporan/laporan_detail_page.dart';

class BulanPage extends StatelessWidget {
  final int year;
  final LaporanController laporanController = Get.find<LaporanController>();

  BulanPage({required this.year, super.key});

  @override
  Widget build(BuildContext context) {
    laporanController.fetchMonths(year);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Bulan - $year"),
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (laporanController.months.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: laporanController.months.length,
          itemBuilder: (context, index) {
            final month = laporanController.months[index];
            return ListTile(
              title: Text(month),
              onTap: () {
                Get.to(() => LaporanDetailPage(year: year, month: index + 1));
              },
            );
          },
        );
      }),
    );
  }
}
