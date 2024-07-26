import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/laporan_controller/laporan_controller.dart';

class LaporanPage extends StatelessWidget {
  final LaporanController laporanController = Get.find<LaporanController>();

  LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 10),
            _buildMonthDropdown(),
            const SizedBox(height: 10),
            _buildReportTypeDropdown(),
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
    return FutureBuilder<List<int>>(
      future: _fetchYears(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data tahun tersedia");
        }

        return DropdownButton<int>(
          hint: const Text("Pilih Tahun"),
          items: snapshot.data!.map((year) {
            return DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            );
          }).toList(),
          onChanged: (year) {
            // Handle year change
          },
        );
      },
    );
  }

  Widget _buildMonthDropdown() {
    return FutureBuilder<List<String>>(
      future: _fetchMonths(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data bulan tersedia");
        }

        return DropdownButton<String>(
          hint: const Text("Pilih Bulan"),
          items: snapshot.data!.map((month) {
            return DropdownMenuItem<String>(
              value: month,
              child: Text(month),
            );
          }).toList(),
          onChanged: (month) {
            // Handle month change
          },
        );
      },
    );
  }

  Widget _buildReportTypeDropdown() {
    return DropdownButton<String>(
      hint: const Text("Pilih Jenis Laporan"),
      items: [
        DropdownMenuItem<String>(
          value: 'hari_ini',
          child: const Text("Laporan Hari Ini"),
        ),
        DropdownMenuItem<String>(
          value: 'minggu_ini',
          child: const Text("Laporan Minggu Ini"),
        ),
        DropdownMenuItem<String>(
          value: 'bulan_ini',
          child: const Text("Laporan Bulan Ini"),
        ),
      ],
      onChanged: (reportType) {
        // Handle report type change
        _fetchReport(reportType!);
      },
    );
  }

  Future<void> _fetchReport(String reportType) async {
    final now = DateTime.now();
    String startDate;
    String endDate = DateFormat('yyyy-MM-dd').format(now);

    if (reportType == 'hari_ini') {
      startDate = endDate;
    } else if (reportType == 'minggu_ini') {
      startDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 7)));
    } else {
      startDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    }

    await laporanController.getLaporan(startDate: startDate, endDate: endDate);
  }

  Future<List<int>> _fetchYears() async {
    // Fetch years from API or database
    return [2021, 2022, 2023]; // Example data
  }

  Future<List<String>> _fetchMonths() async {
    // Fetch months from API or database
    return ["Januari", "Februari", "Maret"]; // Example data
  }
}
