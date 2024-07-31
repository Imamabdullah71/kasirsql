import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'transaksi_detail_page.dart';

class TransaksiHistoryPage extends StatelessWidget {
  final RiwayatController controller = Get.put(RiwayatController());

  TransaksiHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.transaksiList.isEmpty) {
          return const Center(child: Text('Belum ada transaksi', style: TextStyle(fontSize: 18, color: Colors.grey)));
        } else {
          return ListView.builder(
            itemCount: controller.transaksiList.length,
            itemBuilder: (context, index) {
              final transaksi = controller.transaksiList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    title: Text(
                      controller.formatTanggal(transaksi.createdAt),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Total: ${controller.formatRupiah(transaksi.totalHarga)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      controller.fetchDetailTransaksi(transaksi.id!);
                      Get.to(() => TransaksiDetailPage(transaksi: transaksi),
                          transition: Transition.cupertino);
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
      backgroundColor: Colors.white,
    );
  }
}
