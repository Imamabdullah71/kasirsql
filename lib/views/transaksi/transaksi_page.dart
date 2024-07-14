import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';
import 'package:kasirsql/views/transaksi/cart_page.dart';

class TransaksiPage extends StatelessWidget {
  TransaksiPage({super.key});
  final BarangController barangController = Get.find<BarangController>();
  final TransaksiController transaksiController = Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Data Barang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        actions: [
          Obx(() {
            return IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Get.to(() => CartPage());
              },
              tooltip: 'Keranjang (${transaksiController.getTotalBarang()})',
            );
          })
        ],
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
              var detailBarang = transaksiController.selectedBarangList.firstWhere(
                (element) => element['id'] == barang.id,
                orElse: () => {'jumlah': 0},
              );

              return ListTile(
                leading: barang.gambar != null && barang.gambar!.isNotEmpty
                    ? Image.network(
                        'http://10.10.10.80/flutterapi/uploads/${barang.gambar}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
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
                  style: const TextStyle(fontSize: 20),
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
              Get.to(() => CartPage());
            },
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    BootstrapIcons.cart3,
                    color: Colors.white,
                  ),
                  Text(
                    " (${transaksiController.getTotalBarang()})",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              );
            })),
      ),
    );
  }
}
