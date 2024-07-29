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
                            child: SizedBox(
                              width: 55,
                              height: 55,
                              child: Image.network(
                                'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
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
                                      backgroundColor: Colors.grey[
                                          200], // Warna latar belakang indikator
                                      color:
                                          Colors.blue, // Warna utama indikator
                                      valueColor: const AlwaysStoppedAnimation<
                                              Color>(
                                          Colors.red), // Animasi warna progres
                                      strokeWidth: 5.0, // Lebar garis indikator
                                      strokeAlign: BorderSide
                                          .strokeAlignCenter, // Penjajaran stroke (default)
                                      semanticsLabel:
                                          'Loading image', // Label semantik untuk aksesibilitas
                                      semanticsValue:
                                          '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%', // Nilai semantik untuk aksesibilitas
                                      strokeCap: StrokeCap
                                          .round, // Bentuk ujung garis indikator
                                    ));
                                  }
                                },
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  );
                                },
                              ),
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
