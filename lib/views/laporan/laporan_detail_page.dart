// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:kasirsql/controllers/laporan_controller/laporan_controller.dart';

// class LaporanDetailPage extends StatelessWidget {
//   final int year;
//   final int month;
//   final LaporanController laporanController = Get.find<LaporanController>();

//   LaporanDetailPage({required this.year, required this.month, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Laporan - $year/${month.toString().padLeft(2, '0')}"),
//         backgroundColor: const Color.fromARGB(255, 114, 94, 225),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildReportTypeDropdown(),
//             const SizedBox(height: 20),
//             Obx(() {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Total Pemasukan: ${laporanController.totalPemasukan.value}"),
//                   Text("Total Pengeluaran: ${laporanController.totalPengeluaran.value}"),
//                   Text("Laba Bersih: ${laporanController.labaBersih.value}"),
//                 ],
//               );
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReportTypeDropdown() {
//     return DropdownButton<String>(
//       hint: const Text("Pilih Jenis Laporan"),
//       items: const [
//         DropdownMenuItem<String>(
//           value: 'hari_ini',
//           child: Text("Laporan Hari Ini"),
//         ),
//         DropdownMenuItem<String>(
//           value: 'minggu_ini',
//           child: Text("Laporan Minggu Ini"),
//         ),
//         DropdownMenuItem<String>(
//           value: 'bulan_ini',
//           child: Text("Laporan Bulan Ini"),
//         ),
//       ],
//       onChanged: (reportType) {
//         // Handle report type change
//         _fetchReport(reportType!);
//       },
//     );
//   }

//   Future<void> _fetchReport(String reportType) async {
//     final now = DateTime.now();
//     String startDate;
//     String endDate;

//     if (reportType == 'hari_ini') {
//       startDate = endDate = DateFormat('yyyy-MM-dd').format(now);
//     } else if (reportType == 'minggu_ini') {
//       startDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 7)));
//       endDate = DateFormat('yyyy-MM-dd').format(now);
//     } else {
//       startDate = DateFormat('yyyy-MM-dd').format(DateTime(year, month, 1));
//       endDate = DateFormat('yyyy-MM-dd').format(DateTime(year, month + 1, 0));
//     }

//     await laporanController.getLaporan(startDate: startDate, endDate: endDate);
//   }
// }
