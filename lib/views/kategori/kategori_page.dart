import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';
import 'package:kasirsql/models/kategori_model.dart';

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
          onPressed: () {
            _showAddKategoriDialog(context);
          },
          child: const Text(
            "Tambah Kategori",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  void _showAddKategoriDialog(BuildContext context) {
    final TextEditingController namaKategoriController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: TextField(
            controller: namaKategoriController,
            decoration: const InputDecoration(labelText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final String namaKategori = namaKategoriController.text;
                if (namaKategori.isNotEmpty) {
                  kategoriController.createKategori(namaKategori);
                  Get.back();
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
