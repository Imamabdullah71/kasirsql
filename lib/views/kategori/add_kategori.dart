import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';
import 'package:image_picker/image_picker.dart';

class AddKategoriPage extends StatelessWidget {
  AddKategoriPage({super.key});
  final KategoriController kategoriController = Get.find<KategoriController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController namaKategoriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Tambah Kategori",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                if (kategoriController.selectedImagePath.value == '') {
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 60,
                    ),
                  );
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(kategoriController.selectedImagePath.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      kategoriController.pickImage(ImageSource.camera);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Kamera',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      kategoriController.pickImage(ImageSource.gallery);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.image,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Galeri',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: namaKategoriController,
                  decoration: const InputDecoration(labelText: 'Nama Kategori'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Kategori tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
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
            if (_formKey.currentState!.validate()) {
              kategoriController.createKategori(
                namaKategoriController.text,
              );
            }
          },
          child: const Text(
            "Tambahkan",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
