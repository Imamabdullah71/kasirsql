import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';

class TransaksiDetailPage extends StatelessWidget {
  final Transaksi transaksi;
  final RiwayatController controller = Get.find();

  TransaksiDetailPage({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID Transaksi: ${transaksi.id}'),
          Text('Total Barang: ${transaksi.totalBarang}'),
          Text('Total Harga: ${controller.formatRupiah(transaksi.totalHarga)}'),
          Text('Bayar: ${controller.formatRupiah(transaksi.bayar)}'),
          Text('Kembali: ${controller.formatRupiah(transaksi.kembali)}'),
          Text('Tanggal: ${controller.formatTanggal(transaksi.createdAt)}'),
          Expanded(
            child: Obx(() {
              if (controller.detailTransaksiList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: controller.detailTransaksiList.length,
                  itemBuilder: (context, index) {
                    final detail = controller.detailTransaksiList[index];
                    return ListTile(
                      title: Text(detail.namaBarang),
                      subtitle: Text('Jumlah: ${detail.jumlahBarang}'),
                      trailing:
                          Text(controller.formatRupiah(detail.jumlahHarga)),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
