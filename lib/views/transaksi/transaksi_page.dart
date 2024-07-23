import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class TransaksiPage extends StatelessWidget {
  TransaksiPage({super.key});
  final BarangController barangController = Get.find<BarangController>();
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (barangController.barangList.isEmpty) {
          return const Center(child: Text('Tidak ada data barang'));
        }
        return ListView.builder(
          itemCount: barangController.barangList.length,
          itemBuilder: (context, index) {
            final barang = barangController.barangList[index];
            return Obx(() {
              var detailBarang =
                  transaksiController.selectedBarangList.firstWhere(
                (element) => element['id'] == barang.id,
                orElse: () => {'jumlah': 0},
              );

              return ListTile(
                leading: barang.gambar != null && barang.gambar!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://10.0.171.198/flutterapi/uploads/${barang.gambar}',
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                title: Text(barang.namaBarang),
                subtitle: Text(barang.kodeBarang.toString()),
                trailing: Text(
                  "X${detailBarang['jumlah']}",
                  style: const TextStyle(fontSize: 15),
                ),
                onTap: () {
                  transaksiController.addBarangToCart(barang);
                },
              );
            });
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 94, 225),
            minimumSize: const Size(
              double.infinity, // Lebar
              48, // Tinggi
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onPressed: () {
            Get.toNamed("/cart_page");
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                BootstrapIcons.cart3,
                color: Colors.white,
              ),
              Obx(() {
                return Text(
                  " (${transaksiController.totalBarang.value})",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
