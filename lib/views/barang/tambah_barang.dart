import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/rupiah_input_formatter.dart';
import 'package:kasirsql/controllers/barang_controller/tambah_barang_controller.dart';
import 'package:image_picker/image_picker.dart';

class TambahBarang extends StatelessWidget {
  TambahBarang({super.key});
  final TambahBarangController tambahBarangController =
      Get.find<TambahBarangController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController namaBarangController = TextEditingController();
    TextEditingController kodeBarangController = TextEditingController();
    TextEditingController stokBarangController = TextEditingController();
    TextEditingController hargaJualController = TextEditingController();
    TextEditingController hargaBeliController = TextEditingController();
    TextEditingController hargaJualInputController = TextEditingController();
    TextEditingController hargaBeliInputController = TextEditingController();
    RxInt selectedKategoriId = 0.obs;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Tambah Barang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                if (tambahBarangController.selectedImagePath.value == '') {
                  return const Icon(
                    Icons.broken_image_rounded,
                    color: Colors.grey,
                    size: 120,
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
                        File(tambahBarangController.selectedImagePath.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              }),
              // const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      tambahBarangController.pickImage(ImageSource.gallery);
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                    ),
                    onPressed: () {
                      tambahBarangController.pickImage(ImageSource.camera);
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: namaBarangController,
                  decoration: const InputDecoration(labelText: 'Nama Barang'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: kodeBarangController,
                  decoration: const InputDecoration(labelText: 'Kode Barang'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kode Barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: stokBarangController,
                  decoration: const InputDecoration(labelText: 'Stok Barang'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Stok Barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: hargaBeliInputController,
                        decoration: const InputDecoration(
                          labelText: 'Harga Beli',
                          prefixText: 'Rp ',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RupiahInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          hargaBeliController.text = value.replaceAll('.', '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga Beli tidak boleh kosong';
                          }
                          if (double.tryParse(value.replaceAll('.', '')) ==
                              null) {
                            return 'Harga Beli harus berupa angka';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextFormField(
                        controller: hargaJualInputController,
                        decoration: const InputDecoration(
                          labelText: 'Harga Jual',
                          prefixText: 'Rp ',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RupiahInputFormatter(),
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          hargaJualController.text = value.replaceAll('.', '');
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga Jual tidak boleh kosong';
                          }
                          if (double.tryParse(value.replaceAll('.', '')) ==
                              null) {
                            return 'Harga Jual harus berupa angka';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() {
                        if (tambahBarangController.kategoriList.isEmpty) {
                          return const Text('Belum ada kategori');
                        }
                        return DropdownButton<int>(
                          value: selectedKategoriId.value == 0
                              ? null
                              : selectedKategoriId.value,
                          hint: const Text('Pilih Kategori'),
                          onChanged: (newValue) {
                            selectedKategoriId.value = newValue!;
                          },
                          items: tambahBarangController.kategoriList
                              .map((kategori) {
                            return DropdownMenuItem<int>(
                              value: kategori.id,
                              child: Text(kategori.namaKategori),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.toNamed("/page_kategori");
                        },
                        icon: const Icon(BootstrapIcons.plus_lg))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                  minimumSize: const Size(
                    double.infinity, // Lebar
                    10, // Tinggi
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      selectedKategoriId.value != 0) {
                    tambahBarangController.createBarang(
                      namaBarangController.text,
                      int.parse(kodeBarangController.text),
                      int.parse(stokBarangController.text),
                      selectedKategoriId.value,
                      double.parse(hargaJualController.text),
                      double.parse(hargaBeliController.text),
                    );

                    if (tambahBarangController.croppedImage.value != null) {
                      tambahBarangController.uploadImage(
                          tambahBarangController.croppedImage.value!);
                    } else {
                      Get.snackbar('Error', 'Please select an image');
                    }
                  } else {
                    Get.snackbar('Error',
                        'Please fill all fields and select a category');
                  }
                },
                child: const Text(
                  "Tambahkan",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
