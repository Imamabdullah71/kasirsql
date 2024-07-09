// views\barang\tambah_barang.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/tambah_barang_controller.dart';

class TambahBarang extends StatelessWidget {
  final TambahBarangController tambahBarangController =
      Get.find<TambahBarangController>();

  TambahBarang({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController namaBarangController = TextEditingController();
    TextEditingController kodeBarangController = TextEditingController();
    TextEditingController stokBarangController = TextEditingController();
    RxInt selectedKategoriId = 0.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barang'),
      ),
      body: Column(
        children: [
                    Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: namaBarangController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: kodeBarangController,
              decoration: const InputDecoration(labelText: 'Kode Barang'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: stokBarangController,
              decoration: const InputDecoration(labelText: 'Stok Barang'),
            ),
          ),
          Obx(() {
            if (tambahBarangController.kategoriList.isEmpty) {
              return const Text('No kategori available');
            }
            return DropdownButton<int>(
              value: selectedKategoriId.value == 0 ? null : selectedKategoriId.value,
              hint: const Text('Pilih Kategori'),
              onChanged: (newValue) {
                selectedKategoriId.value = newValue!;
              },
              items: tambahBarangController.kategoriList.map((kategori) {
                return DropdownMenuItem<int>(
                  value: kategori.id,
                  child: Text(kategori.namaKategori),
                );
              }).toList(),
            );
          }),
          ElevatedButton(
            onPressed: () {
              if (selectedKategoriId.value != 0) {
                tambahBarangController.createBarang(
                  namaBarangController.text,
                  int.parse(kodeBarangController.text),
                  int.parse(stokBarangController.text),
                  selectedKategoriId.value,
                );
              } else {
                Get.snackbar('Error', 'Please select a category');
              }
            },
            child: const Text('Tambah Barang'),
          ),
        ],
      ),
    );
  }
}
