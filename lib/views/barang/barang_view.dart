import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller.dart';

class BarangView extends StatelessWidget {
  final BarangController barangController = Get.put(BarangController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Barang'),
      ),
      body: Column(
        children: [

          Expanded(
            child: Obx(() {
              if (barangController.barangList.isEmpty) {
                return Center(child: Text('No data available'));
              }
              return ListView.builder(
                itemCount: barangController.barangList.length,
                itemBuilder: (context, index) {
                  final barang = barangController.barangList[index];
                  return ListTile(
                    title: Text(barang.namaBarang),
                    subtitle: Text('Kode: ${barang.kodeBarang} | Stok: ${barang.stokBarang} | Kategori: ${barang.namaKategori}'),
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
            ),),
      ),
    );
  }
}
