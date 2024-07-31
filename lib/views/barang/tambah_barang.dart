import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dropdown_search/dropdown_search.dart';
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

  final TextEditingController namaBarangController = TextEditingController();
  final TextEditingController kodeBarangController = TextEditingController();
  final TextEditingController stokBarangController = TextEditingController();
  final TextEditingController hargaJualInputController =
      TextEditingController();
  final TextEditingController hargaBeliInputController =
      TextEditingController();
  final RxInt selectedKategoriId = 0.obs;

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 10),
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
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (tambahBarangController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (tambahBarangController.kategoriList.isEmpty) {
                        return const Text('Belum ada kategori');
                      }
                      return DropdownSearch<String>(
                        items: tambahBarangController.kategoriList
                            .map((kategori) => kategori.namaKategori)
                            .toList(),
                        selectedItem: tambahBarangController.kategoriList
                            .firstWhereOrNull((kategori) =>
                                kategori.id == selectedKategoriId.value)
                            ?.namaKategori,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Pilih Kategori",
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 114, 94, 225),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          var selectedKategori =
                              tambahBarangController.kategoriList.firstWhere(
                                  (kategori) => kategori.namaKategori == value);
                          selectedKategoriId.value = selectedKategori.id;
                        },
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: "Cari Kategori",
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 114, 94, 225),
                                ),
                              ),
                            ),
                          ),
                          fit: FlexFit.loose,
                          constraints: BoxConstraints.tightFor(
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      );
                    }),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed("/page_kategori");
                    },
                    icon: const Icon(BootstrapIcons.plus_lg),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: namaBarangController,
                decoration: InputDecoration(
                  labelText: 'Nama Barang',
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 114, 94, 225),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Barang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: kodeBarangController,
                decoration: InputDecoration(
                  labelText: 'Barcode Barang',
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 114, 94, 225),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode Barang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: stokBarangController,
                decoration: InputDecoration(
                  labelText: 'Stok Barang',
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 114, 94, 225),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  contentPadding: const EdgeInsets.only(left: 20),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok Barang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: hargaBeliInputController,
                        decoration: InputDecoration(
                          labelText: 'Harga Beli',
                          prefixText: 'Rp ',
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 114, 94, 225),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RupiahInputFormatter(),
                        ],
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
                        keyboardType: TextInputType.number,
                        controller: hargaJualInputController,
                        decoration: InputDecoration(
                          labelText: 'Harga Jual',
                          prefixText: 'Rp ',
                          filled: true,
                          fillColor: Colors.white,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 114, 94, 225),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          RupiahInputFormatter(),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Harga Jual tidak boleh kosong';
                          }
                          final hargaJual = double.tryParse(
                              value.replaceAll('.', ''));
                          final hargaBeli = double.tryParse(
                              hargaBeliInputController.text.replaceAll('.', ''));
                          if (hargaJual == null || hargaJual <= 0) {
                            return 'Harga Jual harus berupa angka positif';
                          }
                          if (hargaBeli == null || hargaBeli <= 0) {
                            return 'Harga Beli harus berupa angka positif';
                          }
                          if (hargaJual <= hargaBeli) {
                            return 'Harga Jual harus lebih besar dari Harga Beli';
                          }
                          return null;
                        },
                      ),
                    ),
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
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      selectedKategoriId.value != 0) {
                    if (tambahBarangController.croppedImage.value != null) {
                      await tambahBarangController.uploadImage(
                          tambahBarangController.croppedImage.value!);
                    } else {
                      Get.snackbar('Error', 'Please select an image');
                      return;
                    }

                    tambahBarangController.createBarang(
                      namaBarangController.text,
                      int.parse(kodeBarangController.text),
                      int.parse(stokBarangController.text),
                      selectedKategoriId.value,
                      double.parse(
                          hargaJualInputController.text.replaceAll('.', '')),
                      double.parse(
                          hargaBeliInputController.text.replaceAll('.', '')),
                    );
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