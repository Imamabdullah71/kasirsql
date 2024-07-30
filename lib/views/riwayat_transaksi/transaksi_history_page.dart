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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (controller.transaksiList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: controller.transaksiList.length,
            itemBuilder: (context, index) {
              final transaksi = controller.transaksiList[index];
              return ListTile(
                title: Text(controller.formatTanggal(transaksi.createdAt)),
                onTap: () {
                  controller.fetchDetailTransaksi(transaksi.id!);
                  Get.to(() => TransaksiDetailPage(transaksi: transaksi));
                },
              );
            },
          );
        }
      }),
    );
  }
}
