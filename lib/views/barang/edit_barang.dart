import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/barang_controller/rupiah_input_formatter.dart';
import 'package:kasirsql/models/barang_model.dart';

class EditBarangPage extends StatelessWidget {
  final Barang barang;
  final BarangController barangController = Get.find<BarangController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditBarangPage({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    TextEditingController namaBarangController =
        TextEditingController(text: barang.namaBarang);
    TextEditingController kodeBarangController =
        TextEditingController(text: barang.kodeBarang.toString());
    TextEditingController stokBarangController =
        TextEditingController(text: barang.stokBarang.toString());
    TextEditingController hargaBeliController =
        TextEditingController(text: formatToRupiah(barang.hargaBeli));
    TextEditingController hargaJualController =
        TextEditingController(text: formatToRupiah(barang.hargaJual));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Barang"),
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
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
                  controller: hargaBeliController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Beli',
                    prefixText: 'Rp ',
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
                    if (double.tryParse(value.replaceAll('.', '')) == null) {
                      return 'Harga Beli harus berupa angka';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: hargaJualController,
                  decoration: const InputDecoration(
                    labelText: 'Harga Jual',
                    prefixText: 'Rp ',
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
                    if (double.tryParse(value.replaceAll('.', '')) == null) {
                      return 'Harga Jual harus berupa angka';
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
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              barang.namaBarang = namaBarangController.text;
              barang.kodeBarang = int.parse(kodeBarangController.text);
              barang.stokBarang = int.parse(stokBarangController.text);
              barang.hargaBeli = double.parse(hargaBeliController.text.replaceAll('.', ''));
              barang.hargaJual = double.parse(hargaJualController.text.replaceAll('.', ''));

              barangController.editBarang(barang);
              Get.back();
            }
          },
          child: const Text("Simpan",
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      ),
    );
  }

  String formatToRupiah(double value) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }
}
