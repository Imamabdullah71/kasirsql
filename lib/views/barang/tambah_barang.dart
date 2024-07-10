import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/tambah_barang_controller.dart';

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: hargaJualController,
                  decoration: const InputDecoration(labelText: 'Harga Jual'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga Jual tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Harga Jual harus berupa angka';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: hargaBeliController,
                  decoration: const InputDecoration(labelText: 'Harga Beli'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga Beli tidak boleh kosong';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Harga Beli harus berupa angka';
                    }
                    return null;
                  },
                ),
              ),
              Obx(() {
                if (tambahBarangController.kategoriList.isEmpty) {
                  return const Text('No kategori available');
                }
                return DropdownButton<int>(
                  value: selectedKategoriId.value == 0
                      ? null
                      : selectedKategoriId.value,
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
            } else {
              Get.snackbar(
                  'Error', 'Please fill all fields and select a category');
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
