// views\barang\barang.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/kelola_stok_controller/kelola_stok_page_controller.dart';

class KelolaStokPage extends StatelessWidget {
  KelolaStokPage({super.key});
  final KelolaStokPageController kelolaStokC =
      Get.find<KelolaStokPageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Kelola Stok Barang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (kelolaStokC.barangList.isEmpty) {
                return const Center(child: Text('Tidak ada data barang'));
              }
              return ListView.builder(
                itemCount: kelolaStokC.barangList.length,
                itemBuilder: (context, index) {
                  final barang = kelolaStokC.barangList[index];
                  return ListTile(
                    leading: barang.gambar != null && barang.gambar!.isNotEmpty
                        ? Image.network(
                            'http://192.168.201.39/flutterapi/uploads/${barang.gambar}',
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${barang.kodeBarang}'),
                        Text(kelolaStokC.formatRupiah(barang.hargaBeli)),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Text(
                          '${barang.stokBarang}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          kelolaStokC.formatRupiah(barang.hargaJual),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    onTap: (){
                      
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
