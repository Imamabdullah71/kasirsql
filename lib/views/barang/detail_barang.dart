import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/models/barang_model.dart';

class BarangDetailPage extends StatelessWidget {
  final Barang barang = Get.arguments as Barang;
  final BarangController barangController = Get.find<BarangController>();

  BarangDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Detail Barang',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: barang.gambar != null && barang.gambar!.isNotEmpty
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 200,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Kategori", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(barang.namaKategori,
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Nama Barang", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(barang.namaBarang,
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Kode Barang", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text('${barang.kodeBarang}',
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Stok", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text('${barang.stokBarang}',
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Harga Jual", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(barangController.formatRupiah(barang.hargaJual),
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Text("Harga Beli", style: TextStyle(fontSize: 18)),
                ),
                const Text(": ", style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(barangController.formatRupiah(barang.hargaBeli),
                      style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/barang-edit', arguments: barang);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                    ),
                    child: const Text('Edit Barang'),
                  ),
                ),
                const SizedBox(width: 16),
                // Button widget inside your UI
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                                'Apakah Anda yakin ingin menghapus barang ini?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  barangController.deleteBarang(barang.id);
                                  Get.back();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Hapus Barang'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
