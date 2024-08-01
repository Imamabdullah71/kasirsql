import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'tampil_struk_page.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID Transaksi: ${transaksi.id}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Barang: ${transaksi.totalBarang}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Harga: ${controller.formatRupiah(transaksi.totalHarga)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Bayar: ${controller.formatRupiah(transaksi.bayar)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kembali: ${controller.formatRupiah(transaksi.kembali)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tanggal: ${controller.formatTanggal(transaksi.createdAt)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.detailTransaksiList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: controller.detailTransaksiList.length,
                    itemBuilder: (context, index) {
                      final detail = controller.detailTransaksiList[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(detail.namaBarang),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${detail.jumlahBarang} x ${detail.hargaBarang}'),
                              Text(controller.formatRupiah(detail.jumlahHarga)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            const SizedBox(height: 20),
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    controller.toggleButtonPress();
                  },
                  onTapUp: (_) {
                    controller.toggleButtonPress();
                    if (transaksi.struk != null &&
                        transaksi.struk!.isNotEmpty) {
                      Get.to(
                          () => TampilStrukPage(gambarStruk: transaksi.struk!));
                    } else {
                      Get.snackbar(
                        "Error",
                        "Struk tidak tersedia",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: controller.isPressed.value
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 114, 94, 225),
                                Color.fromARGB(255, 229, 135, 246),
                              ],
                            ),
                      boxShadow: controller.isPressed.value
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: const Text(
                      'Tampilkan Struk',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
