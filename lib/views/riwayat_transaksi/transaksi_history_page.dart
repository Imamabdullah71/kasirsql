import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'package:kasirsql/views/riwayat_transaksi/transaksi_detail_page.dart';

class TransaksiHistoryPage extends StatelessWidget {
  final RiwayatController riwayatController = Get.find<RiwayatController>();

  TransaksiHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: FutureBuilder(
        future: riwayatController.getTransaksi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data transaksi.'));
          }

          List transaksiList = snapshot.data as List;

          return ListView.builder(
            itemCount: transaksiList.length,
            itemBuilder: (context, index) {
              var transaksi = transaksiList[index];
              double totalHarga =
                  double.tryParse(transaksi['total_harga'].toString()) ?? 0.0;
              return ListTile(
                title: Text('Transaksi ${transaksi['id']}'),
                // Text('Total Harga: ${riwayatController.formatRupiah(totalHarga)}'),
                subtitle: Text(
                    'Total: ${riwayatController.formatRupiah(totalHarga)}'),
                onTap: () {
                  Get.to(() => TransaksiDetailPage(transaksi: transaksi));
                },
              );
            },
          );
        },
      ),
    );
  }
}
