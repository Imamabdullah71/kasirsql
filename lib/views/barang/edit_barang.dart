import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/barang_controller/rupiah_input_formatter.dart';
import 'package:kasirsql/controllers/barang_controller/tambah_barang_controller.dart';
import 'package:kasirsql/models/barang_model.dart';

class EditBarangPage extends StatelessWidget {
  final Barang barang;
  final BarangController barangController = Get.find<BarangController>();
  final TambahBarangController tambahBarangController =
      Get.put(TambahBarangController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RxBool isEditingImage = false.obs;

  EditBarangPage({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    TextEditingController namaBarangController =
        TextEditingController(text: barang.namaBarang);
    TextEditingController kodeBarangController =
        TextEditingController(text: barang.barcodeBarang.toString());
    TextEditingController stokBarangController =
        TextEditingController(text: barang.stokBarang.toString());
    TextEditingController hargaBeliController =
        TextEditingController(text: formatToRupiah(barang.hargaBeli));
    TextEditingController hargaJualController =
        TextEditingController(text: formatToRupiah(barang.hargaJual));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Edit Barang",
          style: TextStyle(
              color: Color.fromARGB(255, 114, 94, 225),
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  Obx(() {
                    if (tambahBarangController.selectedImagePath.value == '' &&
                        barang.gambar == null) {
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
                          child: tambahBarangController
                                  .selectedImagePath.value.isEmpty
                              ? Image.network(
                                  'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(tambahBarangController
                                      .selectedImagePath.value),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      );
                    }
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(BootstrapIcons.pencil),
                      color: Colors.white,
                      onPressed: () {
                        isEditingImage.value = !isEditingImage.value;
                      },
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (isEditingImage.value) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              tambahBarangController
                                  .pickImage(ImageSource.camera);
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
                        ),
                        const SizedBox(width: 10),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              tambahBarangController
                                  .pickImage(ImageSource.gallery);
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.image,
                                    size: 18, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  'Galeri',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
              const SizedBox(height: 20),
              TextFormField(
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
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: stokBarangController,
                        decoration: InputDecoration(
                          labelText: 'Stok',
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
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Stok Barang tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          contentPadding: const EdgeInsets.only(left: 20),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Barcode Barang tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await scanBarcode(kodeBarangController);
                        },
                        icon: const Icon(BootstrapIcons.upc_scan))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: hargaBeliController,
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
                        keyboardType: TextInputType.number,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: hargaJualController,
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
                        keyboardType: TextInputType.number,
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
              const SizedBox(height: 20),
              Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    barangController.toggleButtonPress();
                  },
                  onTapUp: (_) {
                    barangController.toggleButtonPress();
                    if (_formKey.currentState!.validate()) {
                      barang.namaBarang = namaBarangController.text;
                      barang.barcodeBarang =
                          int.parse(kodeBarangController.text);
                      barang.stokBarang = int.parse(stokBarangController.text);
                      barang.hargaBeli = double.parse(
                          hargaBeliController.text.replaceAll('.', ''));
                      barang.hargaJual = double.parse(
                          hargaJualController.text.replaceAll('.', ''));

                      barangController.editBarang(
                        barang,
                        newImage: tambahBarangController.croppedImage.value,
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: barangController.isPressed.value
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 114, 94, 225),
                                Color.fromARGB(255, 229, 135, 246),
                              ],
                            ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String formatToRupiah(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> scanBarcode(TextEditingController kodeBarangController) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Warna garis untuk scanning
      'Cancel', // Teks tombol batal
      true, // Apakah harus menampilkan flash kamera
      ScanMode.BARCODE, // Mode scan (BARCODE atau QR)
    );

    if (barcodeScanRes != '-1') {
      barang.barcodeBarang = int.parse(barcodeScanRes);
      tambahBarangController.setBarcode(barcodeScanRes);
      kodeBarangController.text = barcodeScanRes;
    }
  }
}
