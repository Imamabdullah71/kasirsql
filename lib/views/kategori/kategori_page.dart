import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:kasirsql/views/kategori/add_kategori.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});
  final KategoriController kategoriController = Get.find<KategoriController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Kelola Kategori",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (kategoriController.kategoriList.isEmpty) {
          return const Center(child: Text('Tidak ada kategori'));
        }
        return ListView.builder(
          itemCount: kategoriController.kategoriList.length,
          itemBuilder: (context, index) {
            final Kategori kategori = kategoriController.kategoriList[index];
            return ListTile(
              leading: kategori.gambar != null && kategori.gambar!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://192.168.148.238/flutterapi/uploads/${kategori.gambar}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
              title: Text(kategori.namaKategori),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  kategoriController.deleteKategori(kategori.id);
                },
              ),
            );
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
          onPressed: () => Get.to(
              () => AddKategoriPage()), // Pindah ke halaman tambah kategori
          child: const Text(
            "Tambah Kategori",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
