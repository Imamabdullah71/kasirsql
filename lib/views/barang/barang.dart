// views\barang\barang.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';

class BarangPage extends StatelessWidget {
  BarangPage({super.key});
  final BarangController barangController = Get.find<BarangController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Daftar Barang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (barangController.barangList.isEmpty) {
                return const Center(child: Text('Tidak ada data barang'));
              }
              return ListView.builder(
                itemCount: barangController.barangList.length,
                itemBuilder: (context, index) {
                  final barang = barangController.barangList[index];
                  return ListTile(
                    onTap: () =>
                        Get.toNamed("/page_detail_barang", arguments: barang),
                    leading: barang.gambar != null && barang.gambar!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'http://192.168.148.238/flutterapi/uploads/${barang.gambar}',
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${barang.kodeBarang}'),
                        Text(
                            'Harga Beli : ${barangController.formatRupiah(barang.hargaBeli)}'),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          'Stok : ${barang.stokBarang}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          barangController.formatRupiah(barang.hargaJual),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
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
            Get.toNamed("/tambah_barang");
          },
          child: const Text(
            "Tambah Barang",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
