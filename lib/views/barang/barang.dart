// views\barang\barang.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller.dart';

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
                    title: Text(barang.namaBarang),
                    subtitle: Text(
                        'Harga Jual: ${barang.hargaJual} | Harga Beli: ${barang.hargaBeli}'),
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
