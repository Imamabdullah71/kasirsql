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
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        elevation: 0,
      ),
      body: Obx(() {
        if (barangController.filteredBarangList.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data barang',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        if (barangController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          itemCount: barangController.filteredBarangList.length,
          itemBuilder: (context, index) {
            final barang = barangController.filteredBarangList[index];
            return Obx(() {
              var detailBarang =
                  transaksiController.selectedBarangList.firstWhere(
                (element) => element['id'] == barang.id,
                orElse: () => {'jumlah_barang': 0},
              );

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: SizedBox(
                    width: 55,
                    height: 55,
                    child: barang.gambar != null && barang.gambar!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      backgroundColor: Colors.grey[200],
                                      color: Colors.blue,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                              Colors.red),
                                      strokeWidth: 5.0,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      semanticsLabel: 'Loading image',
                                      semanticsValue:
                                          '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%',
                                      strokeCap: StrokeCap.round,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                  title: Text(
                    barang.namaBarang,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    barang.kodeBarang.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    "X${detailBarang['jumlah_barang'] ?? 0}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    transaksiController.addBarangToCart(barang);
                  },
                ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
